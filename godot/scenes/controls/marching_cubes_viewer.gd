@tool
extends Node3D
class_name MarchinvCubesViewer

@export var material:Material:
	get:
		return material
	set(value):
		if value == material:
			return
		material = value
		update_material()

@export var material_points:Material:
	get:
		return material_points
	set(value):
		if value == material_points:
			return
		material_points = value
		update_material_points()

@export var image_data:ZippedImageStack:
	get:
		return image_data
	set(value):
		if value == image_data:
			return
		image_data = value
		dirty = true
		
@export_range(0, 1) var threshold:float = .5:
	get:
		return threshold
	set(value):
		if value == threshold:
			return
		threshold = value
		dirty = true

@export var step_size:Vector3 = Vector3(8, 8, 8):
	get:
		return step_size
	set(value):
		if value == step_size:
			return
		step_size = value
		dirty = true

@export var cell_min:Vector3i = Vector3i(0, 0, 0):
	get:
		return cell_min
	set(value):
		if value == cell_min:
			return
		cell_min = value
		dirty = true


@export var cell_max:Vector3 = Vector3i(10, 10, 10):
	get:
		return cell_max
	set(value):
		if value == cell_max:
			return
		cell_max = value
		dirty = true


var dirty:bool = true

func update_material():
	if %mesh && %mesh.mesh:
		var mesh:Mesh = %mesh.mesh
		mesh.surface_set_material(0, material)

func update_material_points():
	if %mesh_points && %mesh_points.mesh:
		var mesh:Mesh = %mesh_points.mesh
		mesh.surface_set_material(0, material_points)

#func calc_edge_weight(threashold, p0_val, p1_val):
#	return (threashold - p0_val) / (p1_val - p0_val)

func build_mesh_points(threshold:float, step_size:Vector3):
	if !image_data:
		%mesh.mesh = null
		return
	
	
	var res:Dictionary = MarchingCubes.build_mesh_points(image_data, threshold, step_size)

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = res["points"]
	arrays[Mesh.ARRAY_COLOR] = res["colors"]

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS, arrays)
	#arr_mesh.surface_set_material(0, material)
	print("Setting points mesh")
	%mesh_points.mesh = arr_mesh	

func build_mesh(threshold:float, step_size:Vector3):
	if !image_data:
		%mesh.mesh = null
		return
	
	var res:Dictionary = MarchingCubes.build_mesh(image_data, threshold, step_size)
	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = res["points"]
	arrays[Mesh.ARRAY_NORMAL] = res.normals

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	arr_mesh.surface_set_material(0, material)
	%mesh.mesh = arr_mesh
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dirty:
		build_mesh(threshold, step_size)
		build_mesh_points(threshold, step_size)
		dirty = false
	pass
