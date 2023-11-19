
# Cube corner indexing
#
#       2-------------3
#      /|            /|  
#     /             / |
#    /  |          /  |
#   /             /   |
#  /    |        /    |
# 6-------------7     |
# |     0 -  -  |-  - 1
# |             |    /  
# |   /         |   /
# |             |  /
# | /           | /
# |             |/
# 4-------------5 
#
#
# Cube edge indexing
#
#       +------8------+
#      /|            /| 
#     /             / |
#   11  4          9  |
#   /             /   5
#  /    |        /    |
# +------10-----+     |
# |     + -  -0 |-  - +
# |    /        |    /
# 7   3         6   1
# |             |  /
# | /           | /
# |             |/
# +------2------+

extends RefCounted
class_name MarchingCubes


static func get_edge_point(edge_idx:int, edge_weights:Array[float])->Vector3:
	match edge_idx:
		0:
			return Vector3(edge_weights[0], 0, 0)
		1:
			return Vector3(1, 0, edge_weights[1])
		2:
			return Vector3(edge_weights[2], 0, 1)
		3:
			return Vector3(0, 0, edge_weights[3])
		4:
			return Vector3(0, edge_weights[4], 0)
		5:
			return Vector3(1, edge_weights[5], 0)
		6:
			return Vector3(1, edge_weights[6], 1)
		7:
			return Vector3(0, edge_weights[7], 1)
		8:
			return Vector3(edge_weights[8], 1, 0)
		9:
			return Vector3(1, 1, edge_weights[9])
		10:
			return Vector3(edge_weights[10], 1, 1)
		11:
			return Vector3(0, 1, edge_weights[11])
	
	assert(false, "Invalid value")
	return Vector3.INF


static func create_cube_mesh(cube_idx:int, edge_weights:Array[float])->PackedVector3Array:
	var result:PackedVector3Array
	var edge_list:Array = MarchingCubeTable.get_tessellation_table()[cube_idx]

	for edge_idx in edge_list:
		result.append(get_edge_point(edge_idx, edge_weights))
			
	return result

static func calc_normal_at_point(p:Vector3, image_data:ZippedImageStack)->Vector3:
	
	return Vector3()
	

static func calc_edge_weight(threashold, p0_val, p1_val):
	return (threashold - p0_val) / (p1_val - p0_val)

static func build_mesh(image_data:ZippedImageStack, threshold:float, step_size:Vector3):
	
	var mesh_tri_verts:PackedVector3Array
	var mesh_tri_norms:PackedVector3Array
	
	var data_size:Vector3i = image_data.data_size
	var num_steps_x:float = data_size.x / step_size.x
	var num_steps_y:float = data_size.y / step_size.y
	var num_steps_z:float = data_size.z / step_size.z

	#var gradients:ImageGradient = image_data.calc_gradients()
	
#	print("data_size ", image_data.data_size)
#	print("num_steps_x ", num_steps_x)
#	print("num_steps_y ", num_steps_y)
#	print("num_steps_z ", num_steps_z)
#
#	for cell_z in num_steps_z:
#		for cell_y in num_steps_y:
#			for cell_x in num_steps_x:
	for cell_z in range(-1, num_steps_z + 1):
		for cell_y in range(-1, num_steps_y + 1):
			for cell_x in range(-1, num_steps_x + 1):
					
				var cx0 = cell_x * step_size.x
				var cx1 = (cell_x + 1) * step_size.x
				var cy0 = cell_y * step_size.y
				var cy1 = (cell_y + 1) * step_size.y
				var cz0 = cell_z * step_size.z
				var cz1 = (cell_z + 1) * step_size.z
				
				var s0:float = image_data.get_cell_value(Vector3i(cx0, cy0, cz0))
				var s1:float = image_data.get_cell_value(Vector3i(cx1, cy0, cz0))
				var s2:float = image_data.get_cell_value(Vector3i(cx0, cy1, cz0))
				var s3:float = image_data.get_cell_value(Vector3i(cx1, cy1, cz0))
				var s4:float = image_data.get_cell_value(Vector3i(cx0, cy0, cz1))
				var s5:float = image_data.get_cell_value(Vector3i(cx1, cy0, cz1))
				var s6:float = image_data.get_cell_value(Vector3i(cx0, cy1, cz1))
				var s7:float = image_data.get_cell_value(Vector3i(cx1, cy1, cz1))
				
				var cube_index:int = (0x1 if s0 > threshold else 0) \
					| (0x2 if s1 > threshold else 0) \
					| (0x4 if s2 > threshold else 0) \
					| (0x8 if s3 > threshold else 0) \
					| (0x10 if s4 > threshold else 0) \
					| (0x20 if s5 > threshold else 0) \
					| (0x40 if s6 > threshold else 0) \
					| (0x80 if s7 > threshold else 0)

				if cube_index == 0 || cube_index == 0xff:
					continue
				
#				var edge_weights:Array[float] = [.5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, .5, ]
				var edge_weights:Array[float] = [
					calc_edge_weight(threshold, s0, s1),
					calc_edge_weight(threshold, s1, s5),
					calc_edge_weight(threshold, s4, s5),
					calc_edge_weight(threshold, s0, s4),

					calc_edge_weight(threshold, s0, s2),
					calc_edge_weight(threshold, s1, s3),
					calc_edge_weight(threshold, s5, s7),
					calc_edge_weight(threshold, s4, s6),

					calc_edge_weight(threshold, s2, s3),
					calc_edge_weight(threshold, s3, s7),
					calc_edge_weight(threshold, s6, s7),
					calc_edge_weight(threshold, s2, s6),
				]
				
#				print("Loading cube ", Vector3i(cell_x, cell_y, cell_z))
					
				var xform_local:Transform3D = Transform3D.IDENTITY
				xform_local = xform_local.scaled_local(Vector3(1.0 / data_size.x, 1.0 / data_size.y, 1.0 / data_size.z))
				xform_local = xform_local.translated_local(Vector3(cx0, cy0, cz0))
				xform_local = xform_local.scaled_local(Vector3(cx1 - cx0, cy1 - cy0, cz1 - cz0))

				var xform_grid:Transform3D = Transform3D.IDENTITY
				xform_grid = xform_grid.translated_local(Vector3(cx0, cy0, cz0))
				xform_grid = xform_grid.scaled_local(Vector3(cx1 - cx0, cy1 - cy0, cz1 - cz0))

				var cube_tris:PackedVector3Array = MarchingCubes.create_cube_mesh(cube_index, edge_weights)
				for p_idx in cube_tris.size():
					var point:Vector3 = xform_local * cube_tris[p_idx]
					cube_tris[p_idx] = point
					mesh_tri_verts.append(point)
					
#					var lookup:Vector3 = xform_grid * cube_tris[p_idx]
#					var grad:Vector3 = gradients.get_gradient(lookup)
#					mesh_tri_norms.append(grad.normalized())
					
					
					#var norm:Vector3 = 
				#mesh_tri_verts.append_array(cube_tris)
				

#		print("Loading cube ", cell_z)
				
	print("Cubes loaded")
	
	#Generate normals
	for i in range(0, mesh_tri_verts.size(), 3):
		var p0:Vector3 = mesh_tri_verts[i]
		var p1:Vector3 = mesh_tri_verts[i + 1]
		var p2:Vector3 = mesh_tri_verts[i + 2]
		var norm:Vector3 = ((p1 - p0).cross(p2 - p0)).normalized()

		mesh_tri_norms.append(norm)
		mesh_tri_norms.append(norm)
		mesh_tri_norms.append(norm)
		
	return {
		"points": mesh_tri_verts,
		"normals": mesh_tri_norms
		
	}

static func build_mesh_points(image_data:ZippedImageStack, threshold:float, step_size:Vector3):
	
	var mesh_verts:PackedVector3Array
	var mesh_cols:PackedColorArray
	
	var data_size:Vector3i = image_data.data_size
	var num_steps_x:float = data_size.x / step_size.x
	var num_steps_y:float = data_size.y / step_size.y
	var num_steps_z:float = data_size.z / step_size.z
	
	for cell_z in num_steps_z + 1:
		for cell_y in num_steps_y + 1:
			for cell_x in num_steps_x + 1:
				
				var cx0 = cell_x * step_size.x
				var cy0 = cell_y * step_size.y
				var cz0 = cell_z * step_size.z

				var s000:float = image_data.get_cell_value(Vector3i(cx0, cy0, cz0))

				mesh_verts.append(Vector3(float(cell_x) / num_steps_x, float(cell_y) / num_steps_y, float(cell_z) / num_steps_z))
				mesh_cols.append(Color.WHITE if s000 > threshold else Color.BLACK)

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = mesh_verts
	arrays[Mesh.ARRAY_COLOR] = mesh_cols
	
	return {
		"points": mesh_verts,
		"colors": mesh_cols
	}
