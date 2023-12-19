extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	%slider_threshold.value = %MarchingCubesGlsl.threshold
	%slider_resolution.value = %MarchingCubesGlsl.cube_resolution
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_slider_threshold_value_changed(value):
	%MarchingCubesGlsl.threshold = value


func _on_slider_resolution_value_changed(value):
	%MarchingCubesGlsl.cube_resolution = value


func _on_bn_save_pressed():
	%save_dialog.popup_centered()


func _on_save_dialog_file_selected(save_path:String):
	var path:String = save_path
	if !save_path.to_lower().ends_with(".gltf") && !save_path.to_lower().ends_with(".glb"):
		path = save_path + ".glb"
		
		
	var doc:GLTFDocument = GLTFDocument.new()
	var state:GLTFState = GLTFState.new()
	#var root:Node = plugin.get_editor_interface().get_edited_scene_root()
	#var root_clean:Node3D = clean_flat(root) if %check_flatten.button_pressed else clean_branch(root)
	
	doc.append_from_scene(%MarchingCubesGlsl, state)
	doc.write_to_filesystem(state, path)
		


func _on_bn_load_pressed():
	%load_dialog.popup_centered()


func _on_load_dialog_file_selected(path):
	pass # Replace with function body.
