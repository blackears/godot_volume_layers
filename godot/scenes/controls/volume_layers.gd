#@tool
extends Node3D
class_name VolumeLayers

@export var texture:Texture3D
@export var size:Vector3 = Vector3.ONE

@export var num_layers:int = 10:
	get:
		return num_layers
	set(value):
		if value == num_layers:
			return
		num_layers = value
		rebuild_layers

@export var gradient:GradientTexture1D

var rebuild_layers:bool = true

func create_layers():
	var vertices = PackedVector3Array()
	for i in num_layers:
		#Point in +z
		vertices.push_back(Vector3(-1, -1, float(i) / (num_layers - 1)))
		vertices.push_back(Vector3(1, -1, float(i) / (num_layers - 1)))
		vertices.push_back(Vector3(1, 1, float(i) / (num_layers - 1)))
		
		vertices.push_back(Vector3(-1, -1, float(i) / (num_layers - 1)))
		vertices.push_back(Vector3(1, 1, float(i) / (num_layers - 1)))
		vertices.push_back(Vector3(-1, 1, float(i) / (num_layers - 1)))

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	%mesh.mesh = arr_mesh

	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if rebuild_layers:
#		create_layers()
#		rebuild_layers = false
	pass
