@tool
extends GLSLShaderTool
class_name SobelGradientGenerator

#var rd:RenderingDevice
var shader:RID

func _init(rd:RenderingDevice):
	super._init(rd)
	#rd = RenderingServer.create_local_rendering_device()

	var shader_file:RDShaderFile = load("res://shaders/sobel_gradient_3d.glsl")
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

#Images must all be the same size and have image format FORMAT_RF.  If
# they are not in that format, they will be converted to that format.
func calculate_gradient_from_image_stack(img_list:Array[Image])->Array[Image]:
	var size:Vector3i = Vector3i(img_list[0].get_width(), img_list[0].get_height(), img_list.size())
	
	for img in img_list:
		if img.get_format() != Image.FORMAT_RF:
			img.convert(Image.FORMAT_RF)
	
	#Pack images into texture
	var fmt_tex_out:RDTextureFormat = RDTextureFormat.new()
	fmt_tex_out.texture_type = RenderingDevice.TEXTURE_TYPE_3D
	fmt_tex_out.width = size.x
	fmt_tex_out.height = size.y
	fmt_tex_out.depth = size.z
	fmt_tex_out.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
	fmt_tex_out.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	var view := RDTextureView.new()
	
	var data_buffer:PackedByteArray
	for img in img_list:
		data_buffer.append_array(img.get_data())
		
	var tex_layer_rid:RID = rd.texture_create(fmt_tex_out, view, [data_buffer])	
		
	var result_img_list:Array[Image]
	result_img_list = calculate_gradient(tex_layer_rid, size)
	
	rd.free_rid(tex_layer_rid)
	
	return result_img_list

func calculate_gradient(tex_layer_rid:RID, size:Vector3i):
	var pipeline:RID = rd.compute_pipeline_create(shader)
	
	#Source image
	var source_tex_uniform:RDUniform = RDUniform.new()
	source_tex_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	source_tex_uniform.binding = 0
	source_tex_uniform.add_id(tex_layer_rid)

	####
	#Create buffer for floating parameters
#	var param_buffer_float:PackedByteArray = PackedFloat32Array([]).to_byte_array()
#	var param_buffer:RID = rd.storage_buffer_create(param_buffer_float.size(), param_buffer_float)
#
#	var buffer_uniform:RDUniform = RDUniform.new()
#	buffer_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
#	buffer_uniform.binding = 0
#	buffer_uniform.add_id(param_buffer)
	

	####
	#Dest image
	var fmt_tex_out:RDTextureFormat = RDTextureFormat.new()
	fmt_tex_out.texture_type = RenderingDevice.TEXTURE_TYPE_3D
	fmt_tex_out.width = size.x
	fmt_tex_out.height = size.y
	fmt_tex_out.depth = size.z
	fmt_tex_out.format = RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT
	fmt_tex_out.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	var view := RDTextureView.new()
	

	#var output_image:Image = Image.create(image_size.x, image_size.y, false, Image.FORMAT_RGBAF)
	var data:PackedByteArray
	data.resize(size.x * size.y * size.z * 4 * 4)
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
	@warning_ignore("integer_division")
	rd.compute_list_dispatch(compute_list, (size.x - 1) / 4 + 1, (size.y - 1) / 4 + 1, (size.z - 1) / 4 + 1)
	rd.compute_list_end()
	rd.submit()
	rd.sync()
	
	var byte_data:PackedByteArray = rd.texture_get_data(dest_tex, 0)
	
	var result_img_list:Array[Image]
	var num_image_pixels:int = size.x * size.y
	for i in size.z:
		var image_data:PackedByteArray = byte_data.slice(num_image_pixels * 4 * 4 * i, num_image_pixels * 4 * 4 * (i + 1))
		var img:Image = Image.create_from_data(size.x, size.y, false, Image.FORMAT_RGBAF, image_data)
		result_img_list.append(img)

	rd.free_rid(pipeline)
	rd.free_rid(dest_tex)
	
	return result_img_list
	
