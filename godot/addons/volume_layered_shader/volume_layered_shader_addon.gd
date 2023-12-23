@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("VolumeLayeredShader", "Node3D", 
		preload("res://addons/volume_layered_shader/scenes/controls/volume_layered_shader.gd"), 
		preload("res://addons/art/volume_layered.svg"))
		
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("VolumeLayeredShader")
	pass
