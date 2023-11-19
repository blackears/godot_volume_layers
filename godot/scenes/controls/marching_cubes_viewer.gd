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
	
	
#
#	var mesh_verts:PackedVector3Array
#	var mesh_cols:PackedColorArray
#
#	var data_size:Vector3i = image_data.data_size
#	var num_steps_x:float = data_size.x / step_size.x
#	var num_steps_y:float = data_size.y / step_size.y
#	var num_steps_z:float = data_size.z / step_size.z
#
#	for cell_z in num_steps_z + 1:
#		for cell_y in num_steps_y + 1:
#			for cell_x in num_steps_x + 1:
#				if cell_x < cell_min.x || cell_x >= cell_max.x \
#					|| cell_y < cell_min.y || cell_y >= cell_max.y \
#					|| cell_z < cell_min.z || cell_z >= cell_max.z:
#					continue
#
#				var cx0 = cell_x * step_size.x
#				var cy0 = cell_y * step_size.y
#				var cz0 = cell_z * step_size.z
#
#				var s000:float = image_data.get_cell_value(Vector3i(cx0, cy0, cz0))
#
#				mesh_verts.append(Vector3(float(cell_x) / num_steps_x, float(cell_y) / num_steps_y, float(cell_z) / num_steps_z))
#				mesh_cols.append(Color.WHITE if s000 > threshold else Color.BLACK)

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
	
#	var mesh_tri_verts:PackedVector3Array
#
#	var data_size:Vector3i = image_data.data_size
#	var num_steps_x:float = data_size.x / step_size.x
#	var num_steps_y:float = data_size.y / step_size.y
#	var num_steps_z:float = data_size.z / step_size.z
#
#	print("data_size ", image_data.data_size)
#	print("num_steps_x ", num_steps_x)
#	print("num_steps_y ", num_steps_y)
#	print("num_steps_z ", num_steps_z)
#
#	for cell_z in range(-1, num_steps_z + 1):
#		for cell_y in range(-1, num_steps_y + 1):
#			for cell_x in range(-1, num_steps_x + 1):
#
#				var cx0 = cell_x * step_size.x
#				var cx1 = (cell_x + 1) * step_size.x
#				var cy0 = cell_y * step_size.y
#				var cy1 = (cell_y + 1) * step_size.y
#				var cz0 = cell_z * step_size.z
#				var cz1 = (cell_z + 1) * step_size.z
#
#				var s0:float = image_data.get_cell_value(Vector3i(cx0, cy0, cz0))
#				var s1:float = image_data.get_cell_value(Vector3i(cx1, cy0, cz0))
#				var s2:float = image_data.get_cell_value(Vector3i(cx0, cy1, cz0))
#				var s3:float = image_data.get_cell_value(Vector3i(cx1, cy1, cz0))
#				var s4:float = image_data.get_cell_value(Vector3i(cx0, cy0, cz1))
#				var s5:float = image_data.get_cell_value(Vector3i(cx1, cy0, cz1))
#				var s6:float = image_data.get_cell_value(Vector3i(cx0, cy1, cz1))
#				var s7:float = image_data.get_cell_value(Vector3i(cx1, cy1, cz1))
#
#				var cube_index:int = (0x1 if s0 > threshold else 0) \
#					| (0x2 if s1 > threshold else 0) \
#					| (0x4 if s2 > threshold else 0) \
#					| (0x8 if s3 > threshold else 0) \
#					| (0x10 if s4 > threshold else 0) \
#					| (0x20 if s5 > threshold else 0) \
#					| (0x40 if s6 > threshold else 0) \
#					| (0x80 if s7 > threshold else 0)
#
##				var edge_weights:Array[float] = [.5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, ]
#				var edge_weights:Array[float] = [
#					calc_edge_weight(threshold, s0, s1),
#					calc_edge_weight(threshold, s1, s5),
#					calc_edge_weight(threshold, s4, s5),
#					calc_edge_weight(threshold, s0, s4),
#
#					calc_edge_weight(threshold, s0, s2),
#					calc_edge_weight(threshold, s1, s3),
#					calc_edge_weight(threshold, s5, s7),
#					calc_edge_weight(threshold, s4, s6),
#
#					calc_edge_weight(threshold, s2, s3),
#					calc_edge_weight(threshold, s3, s7),
#					calc_edge_weight(threshold, s6, s7),
#					calc_edge_weight(threshold, s2, s6),
#				]
#
##				print("Loading cube ", Vector3i(cell_x, cell_y, cell_z))
#				if cube_index != 0 && cube_index != 0xff:
#					pass
#
#				var xform:Transform3D = Transform3D.IDENTITY
#				xform = xform.scaled_local(Vector3(1.0 / data_size.x, 1.0 / data_size.y, 1.0 / data_size.z))
#				xform = xform.translated_local(Vector3(cx0, cy0, cz0))
#				xform = xform.scaled_local(Vector3(cx1 - cx0, cy1 - cy0, cz1 - cz0))
#
#				var cube_tris:PackedVector3Array = MarchingCubes.create_cube_mesh(cube_index, edge_weights)
#				for p_idx in cube_tris.size():
##					cube_tris[p_idx] /= Vector3(image_data.data_size.x, image_data.data_size.y, image_data.data_size.z)
#					cube_tris[p_idx] = xform * cube_tris[p_idx]
#					#var norm:Vector3 = 
#				mesh_tri_verts.append_array(cube_tris)
#
#
##		print("Loading cube ", cell_z)
#
#	print("Cubes loaded")
#
#	#Generate normals
#	var mesh_tri_norms:PackedVector3Array
#	for i in range(0, mesh_tri_verts.size(), 3):
#		var p0:Vector3 = mesh_tri_verts[i]
#		var p1:Vector3 = mesh_tri_verts[i + 1]
#		var p2:Vector3 = mesh_tri_verts[i + 2]
#		var norm:Vector3 = ((p1 - p0).cross(p2 - p0)).normalized()
#
#		mesh_tri_norms.append(norm)
#		mesh_tri_norms.append(norm)
#		mesh_tri_norms.append(norm)

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
