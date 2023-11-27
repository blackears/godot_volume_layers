@tool
extends GLSLShaderTool
class_name MarchingCubesGeneratorGLSLVariable

#var shader_mipmap_rid:RID;
var mipmap_gen_rf_3d:MipmapGenerator_rf_3d
var mipmap_gen_rgbaf_3d:MipmapGenerator_RGBAF_3D
var marching_cubes_shader_rid:RID

func _init(rd:RenderingDevice):
	super._init(rd)
	mipmap_gen_rf_3d = MipmapGenerator_rf_3d.new(rd)
	mipmap_gen_rgbaf_3d = MipmapGenerator_RGBAF_3D.new(rd)

	marching_cubes_shader_rid = load_shader_from_path("res://shaders/marching_cubes_mesh_gen_var_len.glsl")
	pass

func dispose():
	mipmap_gen_rf_3d.dispose()
	mipmap_gen_rgbaf_3d.dispose()
	pass

# source_grid_size - dimensions of source image data.  Density and gradient image stacks must both be of this size
# result_grid_size - number of cells in result marching cubes mesh
# threshold - surface density threshold
# img_list_density - image stack with 3d density data
# img_list_gradient - image stack with 3d gradient data
func generate_mesh(result_grid_size:Vector3i, threshold:float, img_list_density:Array[Image], img_list_gradient:Array[Image]):
	
	#Create buffer for read only parameters
	var param_ro_buf:PackedByteArray
	param_ro_buf.resize(8 * 4)
	param_ro_buf.encode_float(0, threshold)
	param_ro_buf.encode_float(1 * 4, 0)
	param_ro_buf.encode_float(2 * 4, 0)
	param_ro_buf.encode_float(3 * 4, 0)
	param_ro_buf.encode_s32(4 * 4, result_grid_size.x)
	param_ro_buf.encode_s32(5 * 4, result_grid_size.y)
	param_ro_buf.encode_s32(6 * 4, result_grid_size.z)
	
#	var param_buffer_float:PackedByteArray = PackedFloat32Array([brush_pos.x, brush_pos.y, radius, 0, color.r, color.g, color.b, color.a]).to_byte_array()
	var param_buffer_ro:RID = rd.storage_buffer_create(param_ro_buf.size(), param_ro_buf)
	
	var buffer_ro_uniform:RDUniform = RDUniform.new()
	buffer_ro_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	buffer_ro_uniform.binding = 0
	buffer_ro_uniform.add_id(param_buffer_ro)
	
	#Create buffer for read-write parameters
	var param_rw_buf:PackedByteArray = PackedInt32Array([0]).to_byte_array()
#	param_rw_buf.resize(4)
#	param_rw_buf.encode_s32(0, 0)
	
#	var param_buffer_float:PackedByteArray = PackedFloat32Array([brush_pos.x, brush_pos.y, radius, 0, color.r, color.g, color.b, color.a]).to_byte_array()
	var param_buffer_rw:RID = rd.storage_buffer_create(param_rw_buf.size(), param_rw_buf)
	
	var buffer_rw_uniform:RDUniform = RDUniform.new()
	buffer_rw_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	buffer_rw_uniform.binding = 1
	buffer_rw_uniform.add_id(param_buffer_rw)
	
	#Density texture
	var density_tex_rid:RID = create_texture_image_from_image_stack(img_list_density, RenderingDevice.DATA_FORMAT_R32_SFLOAT, true)
	
	var samp_density_state:RDSamplerState = RDSamplerState.new()
	var samp_density:RID = rd.sampler_create(samp_density_state)

	var tex_density_uniform:RDUniform = RDUniform.new()
#	tex_density_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
	tex_density_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
	tex_density_uniform.binding = 2
	tex_density_uniform.add_id(samp_density) #Order of add_id() is important here!
	tex_density_uniform.add_id(density_tex_rid)
	
	#Gradient texture
	var grad_tex_rid:RID = create_texture_image_from_image_stack(img_list_gradient, RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT, true)
	
	var samp_grad_state:RDSamplerState = RDSamplerState.new()
	var samp_grad:RID = rd.sampler_create(samp_grad_state)

	var tex_grad_uniform:RDUniform = RDUniform.new()
	tex_grad_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
	tex_grad_uniform.binding = 3
	tex_grad_uniform.add_id(samp_grad) #Order of add_id() is important here!
	tex_grad_uniform.add_id(grad_tex_rid)
	
	#Output buffers
	var max_output_points:int = result_grid_size.x * result_grid_size.y * result_grid_size.z
	#num_points * interleaved buffer * floats per vector * size of float
	var buffer_out_size:int = max_output_points * 2 * 3 * 4
	
	var fmt_tex_out:RDTextureFormat = RDTextureFormat.new()
	fmt_tex_out.texture_type = RenderingDevice.TEXTURE_TYPE_1D
	fmt_tex_out.width = max_output_points * 2 * 3
	fmt_tex_out.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
#	fmt_tex_out.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	fmt_tex_out.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT \
		| RenderingDevice.TEXTURE_USAGE_STORAGE_BIT \
		| RenderingDevice.TEXTURE_USAGE_CPU_READ_BIT \
		| RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	var view:RDTextureView = RDTextureView.new()
	
	var data:PackedByteArray
	data.resize(max_output_points * 4 * 3 * 2)
	data.fill(0)
	var out_points_tex:RID = rd.texture_create(fmt_tex_out, view, [data])

	var dest_tex_uniform:RDUniform = RDUniform.new()
	dest_tex_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	dest_tex_uniform.binding = 4
	dest_tex_uniform.add_id(out_points_tex)
	
	####
	#Set uniforms
	var uniform_set = rd.uniform_set_create([buffer_ro_uniform, buffer_rw_uniform, tex_density_uniform, tex_grad_uniform, dest_tex_uniform], marching_cubes_shader_rid, 0)

	#Run the shader
	var pipeline:RID = rd.compute_pipeline_create(marching_cubes_shader_rid)
	
	var compute_list = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
#	rd.compute_list_dispatch(compute_list, image_size.x / 8, image_size.y / 8, 1)
	@warning_ignore("integer_division")
	rd.compute_list_dispatch(compute_list, \
		(result_grid_size.x - 1) / 4 + 1, \
		(result_grid_size.y - 1) / 4 + 1, \
		(result_grid_size.z - 1) / 4 + 1)
	rd.compute_list_end()
	rd.submit()
	rd.sync()
	
	#Get results
	var param_rw_byte_data:PackedByteArray = rd.buffer_get_data(param_buffer_rw, 0)
	var param_rw_int_data:PackedInt32Array = param_rw_byte_data.to_int32_array()
	var uuu:int = param_rw_byte_data.size()
	
	var out_byte_data:PackedByteArray = rd.texture_get_data(out_points_tex, 0)
	var out_float_data:PackedFloat32Array = out_byte_data.to_float32_array()
	var www:int = out_byte_data.size()
	
	
	
	#########
	#########
	#########
	var start_of_result:PackedFloat32Array = out_float_data.slice(0, 16 * 3)
	
	pass

func get_image_format(format:RenderingDevice.DataFormat)->Image.Format:
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

func get_format_bytes_per_pixel(format:RenderingDevice.DataFormat)->int:
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

#func create_texture_image(size:Vector3i):
func create_texture_image_from_image_stack(img_list:Array[Image], format:RenderingDevice.DataFormat, gen_mipmaps:bool)->RID:
	var size:Vector3i = Vector3i(img_list[0].get_width(), img_list[0].get_height(), img_list.size())
	var img_format:Image.Format = get_image_format(format)
	
	var fmt_tex_out:RDTextureFormat = RDTextureFormat.new()
	fmt_tex_out.texture_type = RenderingDevice.TEXTURE_TYPE_3D
	fmt_tex_out.width = size.x
	fmt_tex_out.height = size.y
	fmt_tex_out.depth = size.z
	fmt_tex_out.mipmaps = 1
#	fmt_tex_out.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
	fmt_tex_out.format = format
#	fmt_tex_out.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT | RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT
	fmt_tex_out.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT
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



func load_shader_from_path(path:String)->RID:
	var shader_file:RDShaderFile = load(path)
	return load_shader(shader_file)
	
func load_shader(shader_file:RDShaderFile)->RID:
	if !shader_file.base_error.is_empty():
		push_error("Error loading shader", "Invalid code")
		print(shader_file.base_error)
		return RID()

	var shader_spirv:RDShaderSPIRV = shader_file.get_spirv()
	if !shader_spirv.compile_error_compute.is_empty():
		push_error("Error compiling shader", "Invalid code")
		print(shader_spirv.compile_error_compute)
		return RID()
	
	var shader_rid:RID = rd.shader_create_from_spirv(shader_spirv)
	return shader_rid
			
