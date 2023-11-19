# This code precomputes the table for cube symmetries.   
#
# Since meny of the different arrangements of cube conrer colorings are rotations, reflections or
# inversions of each other, you can reduce the number of meshes that need to be calculated by
# finding which colorings are related via a set of these simple operations.  This script
# calculates the minimal set of root colorings needed, as well as the transforms needed to
# transform any of the 256 possibilites into one of the root forms.

extends RefCounted
class_name CubeSymmetries


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

#Operations we can apply to the cube to change it's vertex coloring
enum Operations { ROT_X_90, ROT_Y_90, ROT_Z_90, MIRROR_X, MIRROR_Y, MIRROR_Z }

#enum CubeEdge { A, B, C, D, E, F, G, H, I, J, K, L }

#Lookup maps [edge start][operation] -> [edge end]
static var edge_op_table:Array[PackedInt32Array] = [
	#0
	[8, 3, 5, 0, 8, 2],
	#1
	[5, 0, 9, 3, 9, 1],
	#2
	[0, 1, 6, 2, 10, 0],
	#3
	[4, 2, 1, 1, 11, 3],
	#4
	[11, 7, 0, 5, 4, 7],
	#5
	[9, 4, 8, 4, 5, 6],
	#6
	[1, 5, 10, 7, 6, 5],
	#7
	[3, 6, 2, 6, 7, 4],
	#8
	[10, 11, 4, 8, 0, 10],
	#9
	[6, 8, 11, 11, 1, 9],
	#10
	[2, 9, 7, 10, 2, 8],
	#11
	[7, 10, 3, 9, 3, 11],
]

static var root_mesh_edges:Dictionary = {
	0x0:[],
	0x1:[
		0, 3, 4, 
	],
	0x3:[
		1, 3, 5,
		3, 4, 5,
	],
	0x6:[
		0, 5, 1,
		4, 11, 8,
	],
	0x7:[
		1, 3, 11,
		1, 11, 5,
		5, 11, 8,
	],
	0xf:[
		1, 3, 9,
		3, 11, 9,
	],
	0x16:[
		0, 5, 1,
		2, 7, 3,
		4, 11, 8,
	],
	0x17:[
		1, 2, 5,
		2, 7, 5,
		5, 7, 8,
		7, 11, 8,
	],
	0x18:[
		2, 7, 3,
		5, 8, 9,
	],
	0x19:[
		0, 2, 4,
		2, 7, 4,
		5, 8, 9,
	],
	0x1b:[
		1, 2, 9,
		2, 7, 9,
		7, 4, 9,
		4, 8, 9,
	],
	0x1e:[
		0, 9, 1,
		0, 4, 9,
		4, 11, 9,
		2, 7, 3,
	],
	0x1f:[
		1, 2, 9,
		2, 7, 9,
		7, 11, 9,
	],
	0x3c:[
		1, 6, 3,
		3, 6, 7,
		4, 9, 5,
		4, 11, 9,
	],
	0x3d:[
		0, 1, 6,
		0, 6, 7,
		0, 7, 11,
		0, 11, 5,
		5, 11, 9,
	],
	0x3f:[
		6, 7, 9,
		7, 11, 9,
	],
	0x69:[
		0, 3, 4,
		1, 6, 2,
		5, 8, 9,
		7, 10, 11,
	],
	0x6b:[
		2, 3, 6,
		3, 4, 6,
		4, 9, 6,
		4, 8, 9,
		7, 10, 11,
	],
	0x6f:[
		2, 3, 6,
		3, 9, 6,
		3, 7, 9,
		7, 10, 9,
	],
	0x7e:[
		0, 4, 3,
		6, 10, 9,
	],
	0x7f:[
		6, 10, 9,
	],
	0xff:[
	],
}

class ColorGroup extends RefCounted:
	var tessellation:PackedVector3Array

class PeerColoring extends RefCounted:
	var coloring:int
	var operations:PackedInt32Array
	var prev:PeerColoring

	func get_root_coloring()->PeerColoring:
		if !prev:
			return self
		return prev.get_root_coloring()

	func reverse_winding()->bool:
		var count:int = 0
		for op in operations:
			match op:
#				Operations.INVERT:
#					count += 1
				Operations.MIRROR_X:
					count += 1
				Operations.MIRROR_Y:
					count += 1
				Operations.MIRROR_Z:
					count += 1
		
		return (count & 1) == 1
	
	func calc_tranform()->Transform3D:
		var xform:Transform3D = Transform3D.IDENTITY
		
		for op in operations:
			match op:
				Operations.ROT_X_90:
					xform = xform.rotated(Vector3(1, 0, 0), deg_to_rad(90))
				Operations.ROT_Y_90:
					xform = xform.rotated(Vector3(0, 1, 0), deg_to_rad(90))
				Operations.ROT_Z_90:
					xform = xform.rotated(Vector3(0, 0, 1), deg_to_rad(90))
				Operations.MIRROR_X:
					xform = xform.scaled(Vector3(-1, 1, 1))
				Operations.MIRROR_Y:
					xform = xform.scaled(Vector3(1, -1, 1))
				Operations.MIRROR_Z:
					xform = xform.scaled(Vector3(1, 1, -1))

		return xform

			

static func operate_on_edge(edge_index:int, op:Operations)->int:
	return edge_op_table[edge_index][op]

#Pack list of vertex corners into a single int
static func bits_to_int(p0:bool, p1:bool, p2:bool, p3:bool, p4:bool, p5:bool, p6:bool, p7:bool)->int:
	return (0x1 if p0 else 0) \
		| (0x2 if p1 else 0) \
		| (0x4 if p2 else 0) \
		| (0x8 if p3 else 0) \
		| (0x10 if p4 else 0) \
		| (0x20 if p5 else 0) \
		| (0x40 if p6 else 0) \
		| (0x80 if p7 else 0)
		

#Calculate new coloring configuration after applying given operation
static func apply_operation_to_vertices(coloring:int, op:Operations)->int:
	#Decode coloring bits into xyz
	var p000:bool = (coloring & 0x1) != 0
	var p100:bool = (coloring & 0x2) != 0
	var p010:bool = (coloring & 0x4) != 0
	var p110:bool = (coloring & 0x8) != 0
	var p001:bool = (coloring & 0x10) != 0
	var p101:bool = (coloring & 0x20) != 0
	var p011:bool = (coloring & 0x40) != 0
	var p111:bool = (coloring & 0x80) != 0
	
	match op:
#		Operations.INVERT:
#			return bits_to_int(!p000, !p100, !p010, !p110, !p001, !p101, !p011, !p111)
		Operations.ROT_X_90:
			return bits_to_int(p001, p101, p000, p100, p011, p111, p010, p110)
		Operations.ROT_Y_90:
			return bits_to_int(p100, p101, p110, p111, p000, p001, p010, p011)
		Operations.ROT_Z_90:
			return bits_to_int(p010, p000, p110, p100, p011, p001, p111, p101)
		Operations.MIRROR_X:
			return bits_to_int(p100, p000, p110, p010, p101, p001, p111, p011)
		Operations.MIRROR_Y:
			return bits_to_int(p010, p110, p000, p100, p011, p111, p001, p101)
		Operations.MIRROR_Z:
			return bits_to_int(p001, p101, p011, p111, p000, p100, p010, p110)
			
	assert(false, "Illegal operation")
	return 0
		
static func has_coloring(coloring:int, peer_colorings:Array[PeerColoring])->bool:
	for peer in peer_colorings:
		if peer.coloring == coloring:
			return true
	return false

static func find_peer_colorings_recursive(cur_coloring:PeerColoring, found_colorings:Array[PeerColoring]):

	for op in Operations.size():
#		if cur_coloring.coloring == 1:
#			pass
		var new_coloring:int = apply_operation_to_vertices(cur_coloring.coloring, op)
		if !has_coloring(new_coloring, found_colorings):
			var peer_coloring:PeerColoring = PeerColoring.new()
			peer_coloring.coloring = new_coloring
			peer_coloring.operations = cur_coloring.operations.duplicate()
			peer_coloring.operations.append(op)
			peer_coloring.prev = cur_coloring
			found_colorings.append(peer_coloring)
			
			find_peer_colorings_recursive(peer_coloring, found_colorings)

static func find_all_groups()->Array[PeerColoring]:
	var found_colorings:Array[PeerColoring]
	
	#var group_id:int = 0
	var start_colorings:Array[PeerColoring]
	
	for i in 0x100:
		if !has_coloring(i, found_colorings):
			var peer_coloring:PeerColoring = PeerColoring.new()
			peer_coloring.coloring = i
			found_colorings.append(peer_coloring)
			start_colorings.append(peer_coloring)
			
			find_peer_colorings_recursive(peer_coloring, found_colorings)
		
	return found_colorings

static func format_op_list(op_list:Array[int]):
	var strn:String = ""
	for op in op_list:
		match op:
#			Operations.INVERT:
#				strn += "in"
			Operations.ROT_X_90:
				strn += "rx"
			Operations.ROT_Y_90:
				strn += "ry"
			Operations.ROT_Z_90:
				strn += "rz"
			Operations.MIRROR_X:
				strn += "mx"
			Operations.MIRROR_Y:
				strn += "my"
			Operations.MIRROR_Z:
				strn += "mz"
		strn += " "
		
	return strn

static func print_root_colors(colorings:Array[PeerColoring]):
	for col in colorings:
		if col.coloring == col.get_root_coloring().coloring:
			print("root col %0x" % col.coloring)
	
static func print_table(colorings:Array[PeerColoring]):
	
	for coloring in colorings:
		if !coloring.prev:
			#Root coloring
			print("Root coloring: %x" % [coloring.coloring])
		
	colorings.sort_custom(func(a:PeerColoring, b:PeerColoring): return a.coloring < b.coloring)
	for coloring in colorings:
		print("Coloring: %02x  Source: %02x  Xform: %s  Rev Winding: %s Ops: %s " % [coloring.coloring, coloring.get_root_coloring().coloring, str(coloring.calc_tranform()), coloring.reverse_winding(), format_op_list(coloring.operations)])
#
#static func format_table_as_code_gdscript(colorings:Array[PeerColoring])->String:
#	colorings.sort_custom(func(a:PeerColoring, b:PeerColoring): return a.coloring < b.coloring)
#
#	var result:String = ""
#
#
#
#	return result	

			
static func format_table_as_code(colorings:Array[PeerColoring])->String:
	colorings.sort_custom(func(a:PeerColoring, b:PeerColoring): return a.coloring < b.coloring)

	var result:String = ""
	
	for c_idx in colorings.size():
		var coloring:PeerColoring = colorings[c_idx]
		var root_col:int = coloring.get_root_coloring().coloring
		var edge_tri_list:Array = root_mesh_edges[root_col]
		
#		result += "\t[ # %02x (root %02x, rev winding %s)\n" % [c_idx, root_col, coloring.reverse_winding()]
		result += "\t[ # %02x\n" % [c_idx]
		
		for i in range(0, edge_tri_list.size(), 3):
			var a:int
			var b:int
			var c:int
			
			if coloring.reverse_winding():
				a = edge_tri_list[i]
				c = edge_tri_list[i + 1]
				b = edge_tri_list[i + 2]
			else:
				a = edge_tri_list[i]
				b = edge_tri_list[i + 1]
				c = edge_tri_list[i + 2]
				
			for op in coloring.operations:
				a = operate_on_edge(a, op)
				b = operate_on_edge(b, op)
				c = operate_on_edge(c, op)
				
			result += "\t\t%d, %d, %d, \n" % [a, b, c]

		result += "\t],\n"
		
	return result

