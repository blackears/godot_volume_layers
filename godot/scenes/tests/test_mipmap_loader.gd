extends Control

@export_file("*.zip") var zip_file:String:
	get:
		return zip_file
	set(value):
		if value == zip_file:
			return
		zip_file = value

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


func _on_bn_load_mipmaps_pressed():
	var z:ZippedImageArchiveTexture3D = ZippedImageArchiveTexture3D.new()
	var ar:ZippedImageArchive_RF_3D = ZippedImageArchive_RF_3D.new()
	ar.zip_file = zip_file
	z.archive = ar
	#z.zip_file = zip_file
	
	print("Done")

	pass # Replace with function body.


func _on_bn_calc_gradient_pressed():
#	var z:ZippedImagesTexture3D = ZippedImagesTexture3D.new()
	var ar:ZippedImageArchive_RF_3D = ZippedImageArchive_RF_3D.new()
	ar.zip_file = zip_file
	
	var grad_gen:SobelGradientGenerator = SobelGradientGenerator.new()
	var img_size:Vector3i = ar.get_size()
	var image_list:Array[Image] = ar.get_image_list()
	var image_list_base:Array[Image] = image_list.slice(0, img_size.z)
	var grad_image_list:Array[Image] = grad_gen.calculate_gradient_from_image_stack(image_list_base)

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
			
	
	for i in grad_image_list.size():
		grad_image_list[i].save_exr("../export/grad_%d.exr" % i, false)
	
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

