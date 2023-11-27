extends Control

@export_file("*.zip") var zip_file:String:
	get:
		return zip_file
	set(value):
		if value == zip_file:
			return
		zip_file = value

@export_file("*.glsl") var shader_load_test:String

#@export var tex:ZippedImageArchiveTexture3D:
#	get:
#		return tex
#	set(value):
#		if value == tex:
#			return
#		tex = value


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bn_test_gen_mipmaps_pressed():
	var z:ZippedImageArchiveRFTexture3D = ZippedImageArchiveRFTexture3D.new()
	var ar:ZippedImageArchive_RF_3D = ZippedImageArchive_RF_3D.new()
	ar.zip_file = zip_file
	z.archive = ar
	
	var img_list:Array[Image] = ar.get_image_list().duplicate()

	var rd:RenderingDevice = RenderingServer.create_local_rendering_device()
	var gen:MipmapGenerator_rf_3d = MipmapGenerator_rf_3d.new(rd)
	print("test mip num img " + str(img_list.size()))
	var mipmap_images:Array[Image] = gen.calculate(img_list)
	
	img_list.append_array(mipmap_images)
	
	
	%image_stack_viewer.image_list = img_list
	print("Done")

	pass # Replace with function body.


func _on_bn_calc_gradient_pressed():
#	var z:ZippedImagesTexture3D = ZippedImagesTexture3D.new()
	var ar:ZippedImageArchive_RF_3D = ZippedImageArchive_RF_3D.new()
	ar.zip_file = zip_file
	
	var rd:RenderingDevice = RenderingServer.create_local_rendering_device()
	var grad_gen:SobelGradientGenerator = SobelGradientGenerator.new(rd)
	var img_size:Vector3i = ar.get_size()
	var image_list:Array[Image] = ar.get_image_list().duplicate()
	#var image_list_base:Array[Image] = image_list.slice(0, img_size.z)
	var grad_image_list:Array[Image] = grad_gen.calculate_gradient_from_image_stack(image_list)

	var mipmap_gen:MipmapGenerator_RGBAF_3D = MipmapGenerator_RGBAF_3D.new(rd)
	var grad_image_mipmaps:Array[Image] = mipmap_gen.calculate(grad_image_list)

	grad_image_list.append_array(grad_image_mipmaps)
#	for i in image_list_base.size():
#		image_list_base[i].save_exr("../export/base_%d.exr" % i, true)
	
	#grad_gen.calculate_gradient_from_image_stack()
#	var strn:String
#	for j in img_size.y:
#		for i in img_size.x:
#			var color = image_list[120].get_pixel(i, j)
#			strn += "(%f %f %f %f) " % [color.r, color.g, color.b, color.a]
#		strn += "\n"
#	print(strn)
			
	
#	for i in grad_image_list.size():
#		grad_image_list[i].save_exr("../export/grad_%d.exr" % i, false)
	
	%image_stack_viewer.image_list = grad_image_list
	print("done")
	pass # Replace with function body.


func _on_bn_create_cube_mesh_glsl_var_pressed():
	var ar:ZippedImageArchive_RF_3D = ZippedImageArchive_RF_3D.new()
	ar.zip_file = zip_file
	
	var rd:RenderingDevice = RenderingServer.create_local_rendering_device()
	var grad_gen:SobelGradientGenerator = SobelGradientGenerator.new(rd)
	var img_size:Vector3i = ar.get_size()
	var image_list:Array[Image] = ar.get_image_list().duplicate()
	var grad_image_list:Array[Image] = grad_gen.calculate_gradient_from_image_stack(image_list)

#	var mipmap_gen:MipmapGenerator_RGBAF_3D = MipmapGenerator_RGBAF_3D.new(rd)
#	var grad_image_mipmaps:Array[Image] = mipmap_gen.calculate(grad_image_list)
#
#	grad_image_list.append_array(grad_image_mipmaps)
	
	####
	var cube_gen:MarchingCubesGeneratorGLSLVariable = MarchingCubesGeneratorGLSLVariable.new(rd)

	var mesh_size:Vector3i = Vector3i(image_list[0].get_width(), image_list[0].get_height(), image_list.size())
	cube_gen.generate_mesh(mesh_size, .5, image_list, grad_image_list)

	#var dens_tex_rid:RID = cube_gen.create_texture_image_from_image_stack(image_list, true)
	
	pass # Replace with function body.


func _on_bn_create_cube_mesh_glsl_fixed_pressed():
	pass # Replace with function body.

func _on_bn_gen_gradient_kernel_pressed():
	var s:PackedInt32Array = [1, 2, 1]
	var t:PackedInt32Array = [-1, 0, 1]
	
#	var values:PackedInt32Array
	var values:Array[int]
	for k in 3:
		for j in 3:
			for i in 3:
				var x:int = t[i] * s[j] * s[k]
				var y:int = s[i] * t[j] * s[k]
				var z:int = s[i] * s[j] * t[k]
				
				values.append(x)
				values.append(y)
				values.append(z)
	
	var code:String
	for i in range(0, values.size(), 9):
		var line_vals:Array[int] = values.slice(i, i + 9)
		
		code += "\tvec3(%d.0, %d.0, %d.0), vec3(%d.0, %d.0, %d.0), vec3(%d.0, %d.0, %d.0),\n" \
			% line_vals
				
	print(code)




func _on_bn_gen_code_gdscript_pressed():
	var colorings:Array[CubeSymmetries.PeerColoring] = CubeSymmetries.find_all_groups()
	var code:String = CubeSymmetries.format_table_as_code(colorings)
	
	var file:FileAccess = FileAccess.open("cube_code.txt", FileAccess.WRITE)
	file.store_string(code)
	


func _on_bn_calculate_base_cubes_pressed():
	var colorings:Array[CubeSymmetries.PeerColoring] = CubeSymmetries.find_all_groups()
	CubeSymmetries.print_root_colors(colorings)
	


func _on_bn_test_shader_compile_pressed():
	var ctx:GLSLContext = GLSLContext.new()
	
	var sh:GLSLShader = ctx.load_shader_from_path(shader_load_test)
	if sh:
		sh.dispose()
		print("Shader " + shader_load_test + " loaded successfully")


func _on_bn_gen_code_glsl_fixed_pressed():
	var colorings:Array[CubeSymmetries.PeerColoring] = CubeSymmetries.find_all_groups()
	var code:String = CubeSymmetries.format_table_as_glsl_code_fixed_width(colorings)
	
	var file:FileAccess = FileAccess.open("cube_code_glsl_fixed.txt", FileAccess.WRITE)
	file.store_string(code)


func _on_bn_gen_code_glsl_var_pressed():
#	for i in range(0, 5, 2):
#		print("step %d" % i)
	
	var colorings:Array[CubeSymmetries.PeerColoring] = CubeSymmetries.find_all_groups()
	var code:String = CubeSymmetries.format_table_as_glsl_code_var_width(colorings)
	
	var file:FileAccess = FileAccess.open("cube_code_glsl_var.txt", FileAccess.WRITE)
	file.store_string(code)



