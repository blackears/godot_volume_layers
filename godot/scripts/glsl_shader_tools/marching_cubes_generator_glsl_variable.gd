@tool
extends GLSLShaderTool
class_name MarchingCubesGeneratorGLSLVariable

#var shader_mipmap_rid:RID;
var mipmap_gen:MipmapGenerator_rf_3d
var marching_cubes_shader_rid:RID

func _init(rd:RenderingDevice):
	super._init(rd)
	mipmap_gen = MipmapGenerator_rf_3d.new(rd)

	marching_cubes_shader_rid = load_shader_from_path("res://shaders/marching_cubes_mesh_gen_var_len.glsl")
	pass

func dispose():
	mipmap_gen.dispose()
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
	param_ro_buf.encode_float(threshold, 0)
	param_ro_buf.encode_float(0, 1 * 4)
	param_ro_buf.encode_float(0, 2 * 4)
	param_ro_buf.encode_float(0, 3 * 4)
	param_ro_buf.encode_s32(result_grid_size.x, 4 * 4)
	param_ro_buf.encode_s32(result_grid_size.y, 5 * 4)
	param_ro_buf.encode_s32(result_grid_size.z, 6 * 4)
	
#	var param_buffer_float:PackedByteArray = PackedFloat32Array([brush_pos.x, brush_pos.y, radius, 0, color.r, color.g, color.b, color.a]).to_byte_array()
	var param_buffer_ro:RID = rd.storage_buffer_create(param_ro_buf.size(), param_ro_buf)
	
	var buffer_ro_uniform:RDUniform = RDUniform.new()
	buffer_ro_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	buffer_ro_uniform.binding = 0
	buffer_ro_uniform.add_id(param_buffer_ro)
	
	#Create buffer for read-write parameters
	var param_rw_buf:PackedByteArray
	param_rw_buf.resize(4)
	param_rw_buf.encode_s32(0, 0)
	
#	var param_buffer_float:PackedByteArray = PackedFloat32Array([brush_pos.x, brush_pos.y, radius, 0, color.r, color.g, color.b, color.a]).to_byte_array()
	var param_buffer_rw:RID = rd.storage_buffer_create(param_rw_buf.size(), param_rw_buf)
	
	var buffer_rw_uniform:RDUniform = RDUniform.new()
	buffer_rw_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	buffer_rw_uniform.binding = 1
	buffer_rw_uniform.add_id(param_buffer_rw)
	
	#Density texture
	var density_tex_rid:RID = create_texture_image_from_image_stack(img_list_density, true)
	
	var samp_density_state:RDSamplerState = RDSamplerState.new()
	var samp_density:RID = rd.sampler_create(samp_density_state)

	var tex_density_uniform:RDUniform = RDUniform.new()
	tex_density_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
	tex_density_uniform.binding = 2
	tex_density_uniform.add_id(samp_density) #Order of add_id() is important here!
	tex_density_uniform.add_id(density_tex_rid)
	
	#Gradient texture
	var grad_tex_rid:RID = create_texture_image_from_image_stack(img_list_gradient, true)
	
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
	fmt_tex_out.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
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
	var byte_data:PackedByteArray = rd.texture_get_data(out_points_tex, 0)
	var float_data:PackedFloat32Array = byte_data.to_float32_array()
	
	var start_of_result:Array[float] = float_data.slice(0, 16 * 3)
	pass

#func create_texture_image(size:Vector3i):
func create_texture_image_from_image_stack(img_list:Array[Image], gen_mipmaps:bool)->RID:
	var size:Vector3i = Vector3i(img_list[0].get_width(), img_list[0].get_height(), img_list.size())
	
	var fmt_tex_out:RDTextureFormat = RDTextureFormat.new()
	fmt_tex_out.texture_type = RenderingDevice.TEXTURE_TYPE_3D
	fmt_tex_out.width = size.x
	fmt_tex_out.height = size.y
	fmt_tex_out.depth = size.z
	fmt_tex_out.mipmaps = 1
	fmt_tex_out.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
	fmt_tex_out.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	var view:RDTextureView = RDTextureView.new()
	
	var data_buffer:PackedByteArray
	for img in img_list:
		if img.get_format() != Image.FORMAT_RF:
			push_error("Images must be in RF format")
			
		var local_data:PackedByteArray = img.get_data()
		data_buffer.append_array(local_data)
		
	var tex_layer_rid:RID = rd.texture_create(fmt_tex_out, view, [data_buffer])
	
	if gen_mipmaps:
		var mipmap_img_list:Array[Image]
		var num_layers = mipmap_gen.calc_mipmap_recursive(tex_layer_rid, size, mipmap_img_list)
		
		
		rd.free_rid(tex_layer_rid)
		
		#Create mipmapped texture
#		var mipmap_count = 1
#		var layer_count = mipmap_img_list.size()
#		while
		fmt_tex_out.mipmaps = num_layers + 1

#		var ggg = data_buffer.size()
		#data_buffer.clear()

		for i in mipmap_img_list.size():
			var img:Image = mipmap_img_list[i]
			if img.get_format() != Image.FORMAT_RF:
				push_error("Images must be in RF format")

#			var iii = data_buffer.size()

			var local_data:PackedByteArray = img.get_data()
			data_buffer.append_array(local_data)

#			var hhh = data_buffer.size()

		#var jjj = data_buffer.size()
		

#		var fmt_tex_out2:RDTextureFormat = RDTextureFormat.new()
#		fmt_tex_out2.texture_type = RenderingDevice.TEXTURE_TYPE_3D
#		fmt_tex_out2.width = size.x
#		fmt_tex_out2.height = size.y
#		fmt_tex_out2.depth = size.z
#		fmt_tex_out2.mipmaps = num_layers + 1
#		fmt_tex_out2.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
#		fmt_tex_out2.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
#		var view2:RDTextureView = RDTextureView.new()
				
		
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
			
