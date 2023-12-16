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
