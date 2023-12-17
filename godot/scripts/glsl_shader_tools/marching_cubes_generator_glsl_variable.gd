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

func generate_mesh_raw(result_grid_size:Vector3i, threshold:float, mipmap_lod:float, img_list_density:Array[Image], img_list_gradient:Array[Image])->ArrayMesh:
	var density_tex_rid:RID = create_texture_image_from_image_stack(img_list_density, RenderingDevice.DATA_FORMAT_R32_SFLOAT, true)
	var grad_tex_rid:RID = create_texture_image_from_image_stack(img_list_gradient, RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT, true)
	return generate_mesh(result_grid_size, threshold, mipmap_lod, density_tex_rid, grad_tex_rid)

# source_grid_size - dimensions of source image data.  Density and gradient image stacks must both be of this size
# result_grid_size - number of cells in result marching cubes mesh
# threshold - surface density threshold
# img_list_density - image stack with 3d density data
# img_list_gradient - image stack with 3d gradient data
func generate_mesh(result_grid_size:Vector3i, threshold:float, mipmap_lod:float, density_tex_rid:RID, grad_tex_rid:RID)->ArrayMesh:
	var start_time:int = Time.get_ticks_msec()
	
	#Create buffer for read only parameters
	var param_ro_buf:PackedByteArray
	param_ro_buf.resize(8 * 4)
	param_ro_buf.encode_float(0, threshold)
	param_ro_buf.encode_float(1 * 4, mipmap_lod)
	param_ro_buf.encode_float(2 * 4, 0)
	param_ro_buf.encode_float(3 * 4, 0)
	param_ro_buf.encode_s32(4 * 4, result_grid_size.x)
	param_ro_buf.encode_s32(5 * 4, result_grid_size.y)
	param_ro_buf.encode_s32(6 * 4, result_grid_size.z)
	
#	var param_buffer_float:PackedByteArray = PackedFloat32Array([brush_pos.x, brush_pos.y, radius, 0, color.r, color.g, color.b, color.a]).to_byte_array()
	var param_buffer_ro:RID = rd.storage_buffer_create(param_ro_buf.size(), param_ro_buf)
	
	var uniform_buffer_ro:RDUniform = RDUniform.new()
	uniform_buffer_ro.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform_buffer_ro.binding = 0
	uniform_buffer_ro.add_id(param_buffer_ro)
	
	#Create buffer for read-write parameters
	var param_rw_buf:PackedByteArray = PackedInt32Array([0]).to_byte_array()
#	param_rw_buf.resize(4)
#	param_rw_buf.encode_s32(0, 0)
	
#	var param_buffer_float:PackedByteArray = PackedFloat32Array([brush_pos.x, brush_pos.y, radius, 0, color.r, color.g, color.b, color.a]).to_byte_array()
	var param_buffer_rw:RID = rd.storage_buffer_create(param_rw_buf.size(), param_rw_buf)
	
	var uniform_buffer_rw:RDUniform = RDUniform.new()
	uniform_buffer_rw.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform_buffer_rw.binding = 1
	uniform_buffer_rw.add_id(param_buffer_rw)
	
	#Density texture
	var samp_density_state:RDSamplerState = RDSamplerState.new()
	samp_density_state.repeat_u = RenderingDevice.SAMPLER_REPEAT_MODE_CLAMP_TO_BORDER
	samp_density_state.repeat_v = RenderingDevice.SAMPLER_REPEAT_MODE_CLAMP_TO_BORDER
	samp_density_state.repeat_w = RenderingDevice.SAMPLER_REPEAT_MODE_CLAMP_TO_BORDER
	var samp_density:RID = rd.sampler_create(samp_density_state)

	var uniform_tex_density:RDUniform = RDUniform.new()
#	tex_density_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
	uniform_tex_density.uniform_type = RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
	uniform_tex_density.binding = 2
	uniform_tex_density.add_id(samp_density) #Order of add_id() is important here!
	uniform_tex_density.add_id(density_tex_rid)
	
	#Gradient texture
	var samp_grad_state:RDSamplerState = RDSamplerState.new()
	var samp_grad:RID = rd.sampler_create(samp_grad_state)

	var uniform_tex_grad:RDUniform = RDUniform.new()
	uniform_tex_grad.uniform_type = RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
	uniform_tex_grad.binding = 3
	uniform_tex_grad.add_id(samp_grad) #Order of add_id() is important here!
	uniform_tex_grad.add_id(grad_tex_rid)
	
	##################
	##################
	#Output buffers
	var num_grid_cells:int = result_grid_size.x * result_grid_size.y * result_grid_size.z
	#3.65  3.68
	var scale_factor:float = 4.02 # estimate output buffer size based on grid size
	#var scale_factor:float = 1 # estimate output buffer size based on grid size
	var triangle_data_size:int = 3 * 4 * 4 # points per tri * floats per point * bytes per float
	var buffer_out_size:int = int(num_grid_cells * scale_factor) * triangle_data_size
	#print("buffer_out_size ", buffer_out_size)

	var out_point_buffer_data:PackedByteArray
	out_point_buffer_data.resize(buffer_out_size)
#	out_point_buffer_data.fill(0)

	var param_buffer_w_point:RID = rd.storage_buffer_create(out_point_buffer_data.size(), out_point_buffer_data)
	
	var uniform_buffer_w_point:RDUniform = RDUniform.new()
	uniform_buffer_w_point.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform_buffer_w_point.binding = 4
	uniform_buffer_w_point.add_id(param_buffer_w_point)

	###
	var param_buffer_w_normal:RID = rd.storage_buffer_create(out_point_buffer_data.size(), out_point_buffer_data)
	
	var uniform_buffer_w_normal:RDUniform = RDUniform.new()
	uniform_buffer_w_normal.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform_buffer_w_normal.binding = 5
	uniform_buffer_w_normal.add_id(param_buffer_w_normal)
	
	####
	#Set uniforms
#	var uniform_set = rd.uniform_set_create([buffer_ro_uniform, buffer_rw_uniform, tex_density_uniform, tex_grad_uniform, out_points_tex_uniform, out_normals_tex_uniform], marching_cubes_shader_rid, 0)
	var uniform_set = rd.uniform_set_create([uniform_buffer_ro, \
		uniform_buffer_rw, uniform_tex_density, uniform_tex_grad, \
		uniform_buffer_w_point, uniform_buffer_w_normal], marching_cubes_shader_rid, 0)

	#Run the shader
	if true:
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
		rd.full_barrier()
		#rd.barrier(RenderingDevice.BARRIER_MASK_COMPUTE)

	var shader_done_time:int = Time.get_ticks_msec()
	
	#Get results
	var param_rw_byte_data:PackedByteArray = rd.buffer_get_data(param_buffer_rw, 0)
	var param_rw_int_data:PackedInt32Array = param_rw_byte_data.to_int32_array()
	var num_floats_written:int = param_rw_int_data[0]
	#var uuu:int = param_rw_byte_data.size()
	
	var param_w_point_byte_data:PackedByteArray = rd.buffer_get_data(param_buffer_w_point, 0)
	var param_w_point_float_data:PackedFloat32Array = param_w_point_byte_data.to_float32_array()
	
	var param_w_normal_byte_data:PackedByteArray = rd.buffer_get_data(param_buffer_w_normal, 0)
	var param_w_normal_float_data:PackedFloat32Array = param_w_normal_byte_data.to_float32_array()
	
	
	#########
	#########
	#########
	#Convert data to format Godot can use
	#var file_dump:FileAccess = FileAccess.open("dump_buffer.txt", FileAccess.WRITE)
	var points:PackedVector3Array
	var normals:PackedVector3Array
	for i in num_floats_written:
		points.append(Vector3(param_w_point_float_data[i * 3], \
			param_w_point_float_data[i * 3 + 1], param_w_point_float_data[i * 3 + 2]))
		normals.append(Vector3(param_w_normal_float_data[i * 3], \
			param_w_normal_float_data[i * 3 + 1], param_w_normal_float_data[i * 3 + 2]))

		#file_dump.store_line("%f %f %f" % [param_w_normal_float_data[i * 3], \
			#param_w_normal_float_data[i * 3 + 1], param_w_normal_float_data[i * 3 + 2]])
	#file_dump.close()

#	for p in points:
#		print("point " + str(p))

	#print("num_floats_written ", num_floats_written)
	#print("num_points_written ", num_floats_written / 3)
	var limit_start = 3 * 4090
	var limit = 3 * 4096
	var mesh = create_mesh(points.slice(0, num_floats_written / 3), normals.slice(0, num_floats_written / 3))
	
	var build_mesh_done_time:int = Time.get_ticks_msec()
	
	print("time running shader msec:", (shader_done_time - start_time))
	print("time building mesh msec:", (build_mesh_done_time - shader_done_time))
	print("time total msec:", (build_mesh_done_time - start_time))
	
	return mesh
	

func create_mesh(points:PackedVector3Array, normals:PackedVector3Array)->ArrayMesh:
	if false:
		var colors:PackedColorArray
		for n in normals:
			n = (n + Vector3.ONE) / 2
			colors.append(Color(n.x, n.y, n.z, 1))
	
	# Initialize the ArrayMesh.
	var arr_mesh:ArrayMesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = points
	arrays[Mesh.ARRAY_NORMAL] = normals
#	arrays[Mesh.ARRAY_COLOR] = colors

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return arr_mesh


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
	fmt_tex_out.format = format
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
			
