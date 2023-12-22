# MIT License
#
# Copyright (c) 2023 Mark McKay
# https://github.com/blackears/godot_volume_layers
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

@tool
extends GLSLShaderTool
class_name MipmapGenerator_RGBA8_3D

#var rd:RenderingDevice
var shader:RID

func _init(rd:RenderingDevice):
	super._init(rd)
	#rd = RenderingServer.create_local_rendering_device()

	var shader_file:RDShaderFile = load("res://shaders/mipmap_generator_rgba8_3d.glsl")
	if !shader_file.base_error.is_empty():
		push_error("Error loading shader\n", shader_file.base_error)
		return

	var shader_spirv:RDShaderSPIRV = shader_file.get_spirv()
	if !shader_spirv.compile_error_compute.is_empty():
		push_error("Error compiling shader\n", shader_spirv.compile_error_compute)
		return
	
	shader = rd.shader_create_from_spirv(shader_spirv)


func dispose():
	rd.free_rid(shader)


func calculate(img_list:Array[Image])->Array[Image]:
	var mipmap_img_list:Array[Image]
	var size:Vector3i = Vector3i(img_list[0].get_width(), img_list[0].get_height(), img_list.size())
	
	var fmt_tex_out:RDTextureFormat = RDTextureFormat.new()
	fmt_tex_out.texture_type = RenderingDevice.TEXTURE_TYPE_3D
	fmt_tex_out.width = size.x
	fmt_tex_out.height = size.y
	fmt_tex_out.depth = size.z
	fmt_tex_out.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	fmt_tex_out.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	var view := RDTextureView.new()
	
	var data_buffer:PackedByteArray
	for img in img_list:
		data_buffer.append_array(img.get_data())
		
	var tex_layer_rid:RID = rd.texture_create(fmt_tex_out, view, [data_buffer])
	
	calc_mipmap_recursive(tex_layer_rid, size, mipmap_img_list)
	
	rd.free_rid(tex_layer_rid)
	
	return mipmap_img_list


func calc_mipmap_recursive(tex_layer_rid:RID, size:Vector3i, mipmap_img_list:Array[Image]):

	if size.x == 1 && size.y == 1 && size.z == 1:
		return
	
	size = Vector3i(max(1, size.x >> 1), max(1, size.y >> 1), max(1, size.z >> 1))
	
	var pipeline:RID = rd.compute_pipeline_create(shader)
	
	#Source image
	var source_tex_uniform:RDUniform = RDUniform.new()
	source_tex_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	source_tex_uniform.binding = 0
	source_tex_uniform.add_id(tex_layer_rid)

	#Dest image
	var fmt_tex_out:RDTextureFormat = RDTextureFormat.new()
	fmt_tex_out.texture_type = RenderingDevice.TEXTURE_TYPE_3D
	fmt_tex_out.width = size.x
	fmt_tex_out.height = size.y
	fmt_tex_out.depth = size.z
	fmt_tex_out.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	fmt_tex_out.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	var view := RDTextureView.new()
	
	#var output_image:Image = Image.create(image_size.x, image_size.y, false, Image.FORMAT_RGBAF)
	var data:PackedByteArray
	data.resize(size.x * size.y * size.z * 4)
	data.fill(0)
	var dest_tex:RID = rd.texture_create(fmt_tex_out, view, [data])


	var dest_tex_uniform:RDUniform = RDUniform.new()
	dest_tex_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	dest_tex_uniform.binding = 1
	dest_tex_uniform.add_id(dest_tex)
		
	####
	#Set uniforms
	var uniform_set = rd.uniform_set_create([source_tex_uniform, dest_tex_uniform], shader, 0)

	#Run the shader
	var compute_list = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
#	rd.compute_list_dispatch(compute_list, image_size.x / 8, image_size.y / 8, 1)
	@warning_ignore("integer_division")
	rd.compute_list_dispatch(compute_list, (size.x - 1) / 4 + 1, (size.y - 1) / 4 + 1, (size.z - 1) / 4 + 1)
	rd.compute_list_end()
	rd.submit()
	rd.sync()
	
	var byte_data:PackedByteArray = rd.texture_get_data(dest_tex, 0)
#	var float_data:PackedFloat32Array = byte_data.to_float32_array()
	
	var num_image_pixels:int = size.x * size.y
	for i in size.z:
		var image_data:PackedByteArray = byte_data.slice(num_image_pixels * 4 * i, num_image_pixels * 4 * (i + 1))
		var img:Image = Image.create_from_data(size.x, size.y, false, Image.FORMAT_RGBA8, image_data)
		mipmap_img_list.append(img)
		
#		img.save_png("art/mipmap/map_%d.png" % mip_img_idx)
#		mip_img_idx += 1
	#print_floats(float_data, 40)
	
	calc_mipmap_recursive(dest_tex, size, mipmap_img_list)

	rd.free_rid(pipeline)
	rd.free_rid(dest_tex)
	

	
