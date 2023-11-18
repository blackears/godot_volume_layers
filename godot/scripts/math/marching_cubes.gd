extends RefCounted
class_name MarchingCubes


class CubeParams extends RefCounted:
	var a_frac:float = .5
	var b_frac:float = .5
	var c_frac:float = .5
	var d_frac:float = .5
	var e_frac:float = .5
	var f_frac:float = .5
	var g_frac:float = .5
	var h_frac:float = .5
	var i_frac:float = .5
	var j_frac:float = .5
	var k_frac:float = .5
	var l_frac:float = .5

static func create_cube_mesh(coloring:int, cube_params:CubeParams)->PackedVector3Array:
	#Create points based on ratios
	var pa:Vector3 = Vector3(0, 1, cube_params.a_frac)
	var pb:Vector3 = Vector3(cube_params.b_frac, 1, 0)
	var pc:Vector3 = Vector3(1, 1, cube_params.c_frac)
	var pd:Vector3 = Vector3(cube_params.d_frac, 1, 1)
	
	var pe:Vector3 = Vector3(0, cube_params.e_frac, 1)
	var pf:Vector3 = Vector3(0, cube_params.f_frac, 0)
	var pg:Vector3 = Vector3(1, cube_params.g_frac, 0)
	var ph:Vector3 = Vector3(1, cube_params.h_frac, 1)

	var pi:Vector3 = Vector3(0, 0, cube_params.i_frac)
	var pj:Vector3 = Vector3(cube_params.j_frac, 0, 0)
	var pk:Vector3 = Vector3(1, 0, cube_params.k_frac)
	var pl:Vector3 = Vector3(cube_params.l_frac, 0, 1)
	
	
	var result:PackedVector3Array
	var edge_list:Array = MarchingCubeTable.get_mesh_table()[coloring]

	for edge in edge_list:
		match edge:
			CubeSymmetries.CubeEdge.A:
				result.append(pa)
			CubeSymmetries.CubeEdge.B:
				result.append(pb)
			CubeSymmetries.CubeEdge.C:
				result.append(pc)
			CubeSymmetries.CubeEdge.D:
				result.append(pd)
			CubeSymmetries.CubeEdge.E:
				result.append(pe)
			CubeSymmetries.CubeEdge.F:
				result.append(pf)
			CubeSymmetries.CubeEdge.G:
				result.append(pg)
			CubeSymmetries.CubeEdge.H:
				result.append(ph)
			CubeSymmetries.CubeEdge.I:
				result.append(pi)
			CubeSymmetries.CubeEdge.J:
				result.append(pj)
			CubeSymmetries.CubeEdge.K:
				result.append(pk)
			CubeSymmetries.CubeEdge.L:
				result.append(pl)
			
	return result
