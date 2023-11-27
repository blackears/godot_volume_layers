@tool
extends GLSLShaderTool
class_name MarchingCubesGeneratorGLSLVariable

#var shader_mipmap_rid:RID;
var mipmap_gen:MipmapGenerator_rf_3d

func _init(rd:RenderingDevice):
	super._init(rd)
	mipmap_gen = MipmapGenerator_rf_3d.new(rd)
	#shader_mipmap_rid = load_shader_from_path("res://shaders/mipmap_generator_rf_3d.glsl")
	pass

func dispose():
	mipmap_gen.dispose()
	pass

# source_grid_size - dimensions of source image data.  Density and gradient image stacks must both be of this size
# result_grid_size - number of cells in result marching cubes mesh
# threshold - surface density threshold
# img_list_density - image stack with 3d density data
# img_list_gradient - image stack with 3d gradient data
func generate_mesh(source_grid_size:Vector3i, result_grid_size:Vector3i, threshold:float, img_list_density:Array[Image], img_list_gradient:Array[Image]):
	
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

		var ggg = data_buffer.size()
		#data_buffer.clear()

		for i in mipmap_img_list.size():
			var img:Image = mipmap_img_list[i]
			if img.get_format() != Image.FORMAT_RF:
				push_error("Images must be in RF format")

#			var iii = data_buffer.size()

			var local_data:PackedByteArray = img.get_data()
			data_buffer.append_array(local_data)

#			var hhh = data_buffer.size()
			pass

		var jjj = data_buffer.size()
		

		var fmt_tex_out2:RDTextureFormat = RDTextureFormat.new()
		fmt_tex_out2.texture_type = RenderingDevice.TEXTURE_TYPE_3D
		fmt_tex_out2.width = size.x
		fmt_tex_out2.height = size.y
		fmt_tex_out2.depth = size.z
		fmt_tex_out2.mipmaps = num_layers + 1
		fmt_tex_out2.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
		fmt_tex_out2.usage_bits = RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
		var view2:RDTextureView = RDTextureView.new()
				
		
		tex_layer_rid = rd.texture_create(fmt_tex_out2, view2, [data_buffer])
		
	
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
			
