extends Control

@export_file("*.zip") var zip_file:String:
	get:
		return zip_file
	set(value):
		if value == zip_file:
			return
		zip_file = value

@export var tex:ZippedImageArchiveTexture3D:
	get:
		return tex
	set(value):
		if value == tex:
			return
		tex = value


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
	#grad_gen.calculate_gradient_from_image_stack()
	
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

