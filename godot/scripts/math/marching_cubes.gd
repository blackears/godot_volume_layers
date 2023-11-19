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
