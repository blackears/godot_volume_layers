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
extends Resource
class_name GLSLUtil

var rd:RenderingDevice
var mipmap_gen_rf_3d:MipmapGenerator_rf_3d
var mipmap_gen_rgbaf_3d:MipmapGenerator_RGBAF_3D

func _init(rd:RenderingDevice):
	self.rd = rd
	mipmap_gen_rf_3d = MipmapGenerator_rf_3d.new(rd)
	mipmap_gen_rgbaf_3d = MipmapGenerator_RGBAF_3D.new(rd)

static func calc_mipmap_sizes(size:Vector3i)->Array[Vector3i]:
	var result:Array[Vector3i]
	calc_mipmap_sizes_recursive(size, result)
	return result

static func calc_mipmap_sizes_recursive(size:Vector3i, result:Array[Vector3i]):
	result.append(size)
	
	if size == Vector3i.ONE:
		return
		
	var next_size:Vector3i = Vector3i(\
		max(size.x >> 1, 1), \
		max(size.y >> 1, 1), \
		max(size.z >> 1, 1))
	
	calc_mipmap_sizes_recursive(next_size, result)

static func get_image_format(format:RenderingDevice.DataFormat)->Image.Format:
	match format:
		RenderingDevice.DATA_FORMAT_R32_SFLOAT:
			return Image.FORMAT_RF
		RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT:
			return Image.FORMAT_RGBAF
		RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM:
			return Image.FORMAT_RGBA8
		_:
			push_error("Unhandled format")
			return 0

static func get_format_bytes_per_pixel(format:RenderingDevice.DataFormat)->int:
	match format:
		RenderingDevice.DATA_FORMAT_R32_SFLOAT:
			return 4
		RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT:
			return 16
		RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM:
			return 4
		_:
			push_error("Unhandled format")
			return 0

func create_mipmaps_from_image_stack(img_list:Array[Image], format:RenderingDevice.DataFormat)->Array[Image]:
	var img_format:Image.Format = get_image_format(format)
	
	var data_buffer:PackedByteArray
	for img in img_list:
		var cur_format:Image.Format = img.get_format()
		if cur_format != img_format:
			push_error("Images must be in " + str(img_format) + " format")
			
		var local_data:PackedByteArray = img.get_data()
		data_buffer.append_array(local_data)
		
	
	var mipmap_img_list:Array[Image]
	var num_layers:int
	
	mipmap_img_list.append_array(img_list)
	
	if format == RenderingDevice.DATA_FORMAT_R32_SFLOAT:
		var images:Array[Image] = mipmap_gen_rf_3d.calculate(img_list)
		mipmap_img_list.append_array(images)
	if format == RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT:
		var images:Array[Image] = mipmap_gen_rgbaf_3d.calculate(img_list)
		mipmap_img_list.append_array(images)
	
	return mipmap_img_list
	
func create_texture_image_from_image_stack_with_mipmaps(img_list:Array[Image], format:RenderingDevice.DataFormat, size:Vector3i, num_layers:int)->RID:
	var img_format:Image.Format = get_image_format(format)
	
	var fmt_tex_out:RDTextureFormat = RDTextureFormat.new()
	fmt_tex_out.texture_type = RenderingDevice.TEXTURE_TYPE_3D
	fmt_tex_out.width = size.x
	fmt_tex_out.height = size.y
	fmt_tex_out.depth = size.z
	fmt_tex_out.mipmaps = num_layers
	fmt_tex_out.format = format
	fmt_tex_out.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT \
		| RenderingDevice.TEXTURE_USAGE_STORAGE_BIT \
		| RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT
		
	var view:RDTextureView = RDTextureView.new()
		

	var data_buffer:PackedByteArray
	for img in img_list:
		var cur_format:Image.Format = img.get_format()
		if cur_format != img_format:
			push_error("Images must be in " + str(img_format) + " format")
			
		var local_data:PackedByteArray = img.get_data()
		data_buffer.append_array(local_data)
		
	var tex_layer_rid:RID = rd.texture_create(fmt_tex_out, view, [data_buffer])

	return tex_layer_rid
	
		
func create_texture_image_from_image_stack(img_list:Array[Image], format:RenderingDevice.DataFormat, gen_mipmaps:bool)->RID:
	var size:Vector3i = Vector3i(img_list[0].get_width(), img_list[0].get_height(), img_list.size())
	var img_format:Image.Format = get_image_format(format)
	
	var fmt_tex_out:RDTextureFormat = RDTextureFormat.new()
	fmt_tex_out.texture_type = RenderingDevice.TEXTURE_TYPE_3D
	fmt_tex_out.width = size.x
	fmt_tex_out.height = size.y
	fmt_tex_out.depth = size.z
	fmt_tex_out.mipmaps = 1
	fmt_tex_out.format = format
	fmt_tex_out.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT \
		| RenderingDevice.TEXTURE_USAGE_STORAGE_BIT \
		| RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT
	var view:RDTextureView = RDTextureView.new()
	
	var data_buffer:PackedByteArray
	for img in img_list:
		var cur_format:Image.Format = img.get_format()
		if cur_format != img_format:
			push_error("Images must be in " + str(img_format) + " format")
			
		var local_data:PackedByteArray = img.get_data()
		data_buffer.append_array(local_data)
		
	var tex_layer_rid:RID = rd.texture_create(fmt_tex_out, view, [data_buffer])
	
	if gen_mipmaps:
		var mipmap_img_list:Array[Image]
		var num_layers:int
		
		if format == RenderingDevice.DATA_FORMAT_R32_SFLOAT:
			num_layers = mipmap_gen_rf_3d.calc_mipmap_recursive(tex_layer_rid, size, mipmap_img_list)
		if format == RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT:
			num_layers = mipmap_gen_rgbaf_3d.calc_mipmap_recursive(tex_layer_rid, size, mipmap_img_list)
		
		
		rd.free_rid(tex_layer_rid)
		
		#Create mipmapped texture
		fmt_tex_out.mipmaps = num_layers + 1

#		var ggg = data_buffer.size()
		#data_buffer.clear()

		for i in mipmap_img_list.size():
			var img:Image = mipmap_img_list[i]
			var cur_format:Image.Format = img.get_format()
			if cur_format != img_format:
				push_error("Images must be in " + str(img_format) + " format")

#			var iii = data_buffer.size()

			var local_data:PackedByteArray = img.get_data()
			data_buffer.append_array(local_data)

#			var hhh = data_buffer.size()

		#var jjj = data_buffer.size()
		
		
		tex_layer_rid = rd.texture_create(fmt_tex_out, view, [data_buffer])
		
	
	return tex_layer_rid
