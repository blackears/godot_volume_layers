extends Control

@export_file("*.zip") var zip_file:String:
	get:
		return zip_file
	set(value):
		if value == zip_file:
			return
		zip_file = value

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bn_load_mipmaps_pressed():
	var z:ZippedImagesTexture3D = ZippedImagesTexture3D.new()
	z.zip_file = zip_file
	
	print("Done")

	pass # Replace with function body.
