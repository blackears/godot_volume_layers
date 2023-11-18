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



var dirty:bool = true

func update_material():
	if %mesh.mesh:
		var mesh:Mesh = %mesh.mesh
		mesh.surface_set_material(0, material)
		#%mesh.mesh.set_surface_override_material(material)

func calc_ratio(threashold, p0_val, p1_val):
	return (threashold - p0_val) / (p1_val - p0_val)

func build_mesh(threshold:float, step_size:Vector3):
	if !image_data:
		%mesh.mesh = null
		return
	
	var mesh_tri_verts:PackedVector3Array
	
	var data_size:Vector3i = image_data.data_size
	var num_steps_x:float = data_size.x / step_size.x
	var num_steps_y:float = data_size.y / step_size.y
	var num_steps_z:float = data_size.z / step_size.z
	
	for cell_z in num_steps_z:
		for cell_y in num_steps_y:
			for cell_x in num_steps_x:
				var cx0 = cell_x * step_size.x
				var cx1 = (cell_x + 1) * step_size.x
				var cy0 = cell_y * step_size.y
				var cy1 = (cell_y + 1) * step_size.y
				var cz0 = cell_z * step_size.y
				var cz1 = (cell_z + 1) * step_size.y
				
				var s000:float = image_data.get_cell_value(Vector3i(cx0, cy0, cz0))
				var s100:float = image_data.get_cell_value(Vector3i(cx1, cy0, cz0))
				var s010:float = image_data.get_cell_value(Vector3i(cx0, cy1, cz0))
				var s110:float = image_data.get_cell_value(Vector3i(cx1, cy1, cz0))
				var s001:float = image_data.get_cell_value(Vector3i(cx0, cy0, cz1))
				var s101:float = image_data.get_cell_value(Vector3i(cx1, cy0, cz1))
				var s011:float = image_data.get_cell_value(Vector3i(cx0, cy1, cz1))
				var s111:float = image_data.get_cell_value(Vector3i(cx1, cy1, cz1))
				
				var cube_vertex_coloring:int = (0x1 if s000 > threshold else 0) \
					| (0x2 if s100 > threshold else 0) \
					| (0x4 if s010 > threshold else 0) \
					| (0x8 if s110 > threshold else 0) \
					| (0x10 if s001 > threshold else 0) \
					| (0x20 if s101 > threshold else 0) \
					| (0x40 if s011 > threshold else 0) \
					| (0x80 if s111 > threshold else 0)
					
				var params:MarchingCubes.CubeParams = MarchingCubes.CubeParams.new()
#				params.a_frac = calc_ratio(threshold, s010, s011)
#				params.b_frac = calc_ratio(threshold, s010, s110)
#				params.c_frac = calc_ratio(threshold, s011, s111)
#				params.d_frac = calc_ratio(threshold, s011, s111)
#
#				params.e_frac = calc_ratio(threshold, s001, s011)
#				params.f_frac = calc_ratio(threshold, s000, s010)
#				params.g_frac = calc_ratio(threshold, s100, s110)
#				params.h_frac = calc_ratio(threshold, s101, s111)
#
#				params.i_frac = calc_ratio(threshold, s000, s001)
#				params.j_frac = calc_ratio(threshold, s000, s100)
#				params.k_frac = calc_ratio(threshold, s001, s101)
#				params.l_frac = calc_ratio(threshold, s001, s101)
				
#				print("Loading cube ", Vector3i(cell_x, cell_y, cell_z))
				if cube_vertex_coloring != 0 && cube_vertex_coloring != 0xff:
					pass
					
				var xform:Transform3D = Transform3D.IDENTITY
				xform = xform.scaled_local(Vector3(1.0 / data_size.x, 1.0 / data_size.y, 1.0 / data_size.z))
				xform = xform.translated_local(Vector3(cx0, cy0, cz0))
				xform = xform.scaled_local(Vector3(cx1 - cx0, cy1 - cy0, cz1 - cz0))

				var cube_tris:PackedVector3Array = MarchingCubes.create_cube_mesh(cube_vertex_coloring, params)
				for p_idx in cube_tris.size():
#					cube_tris[p_idx] /= Vector3(image_data.data_size.x, image_data.data_size.y, image_data.data_size.z)
					cube_tris[p_idx] = xform * cube_tris[p_idx]
					#var norm:Vector3 = 
				mesh_tri_verts.append_array(cube_tris)
				

		print("Loading cube ", cell_z)
				
	print("Cubes loaded")
	
	#Generate normals
	var mesh_tri_norms:PackedVector3Array
	for i in range(0, mesh_tri_verts.size(), 3):
		var p0:Vector3 = mesh_tri_verts[i]
		var p1:Vector3 = mesh_tri_verts[i + 1]
		var p2:Vector3 = mesh_tri_verts[i + 2]
		var norm:Vector3 = ((p1 - p0).cross(p2 - p0)).normalized()
		
		mesh_tri_norms.append(norm)
		mesh_tri_norms.append(norm)
		mesh_tri_norms.append(norm)

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = mesh_tri_verts
	arrays[Mesh.ARRAY_NORMAL] = mesh_tri_norms

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
		dirty = false
	pass
