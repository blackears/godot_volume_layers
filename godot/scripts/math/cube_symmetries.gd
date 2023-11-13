# This code precomputes the table for cube symmetries.   
#
# Since meny of the different arrangements of cube conrer colorings are rotations, reflections or
# inversions of each other, you can reduce the number of meshes that need to be calculated by
# finding which colorings are related via a set of these simple operations.  This script
# calculates the minimal set of root colorings needed, as well as the transforms needed to
# transform any of the 256 possibilites into one of the root forms.

extends RefCounted
class_name CubeSymmetries

#Bits
# 1 - x-
# 2 - x+
# 3 - y-
# 4 - y+
# 5 - z-
# 6 - z+

#Operations we can apply to the cube to change it's vertex coloring
enum Operations { ROT_X_90, ROT_Y_90, ROT_Z_90, MIRROR_X, MIRROR_Y, MIRROR_Z, INVERT }

enum CubeEdge { A, B, C, D, E, F, G, H, I, J, K, L }

#Location of edge point after performing operation
static var edge_op_table = [
	#A
	[CubeEdge.E, CubeEdge.D, CubeEdge.I, CubeEdge.C, CubeEdge.I, CubeEdge.A, CubeEdge.A],
	#B
	[CubeEdge.D, CubeEdge.A, CubeEdge.F, CubeEdge.B, CubeEdge.J, CubeEdge.D, CubeEdge.B],
	#C
	[CubeEdge.H, CubeEdge.B, CubeEdge.A, CubeEdge.A, CubeEdge.K, CubeEdge.C, CubeEdge.C],
	#D
	[CubeEdge.L, CubeEdge.C, CubeEdge.E, CubeEdge.D, CubeEdge.L, CubeEdge.B, CubeEdge.D],
	#E
	[CubeEdge.I, CubeEdge.H, CubeEdge.L, CubeEdge.H, CubeEdge.E, CubeEdge.F, CubeEdge.E],
	#F
	[CubeEdge.A, CubeEdge.E, CubeEdge.J, CubeEdge.G, CubeEdge.F, CubeEdge.E, CubeEdge.F],
	#G
	[CubeEdge.C, CubeEdge.F, CubeEdge.B, CubeEdge.F, CubeEdge.G, CubeEdge.H, CubeEdge.G],
	#H
	[CubeEdge.K, CubeEdge.G, CubeEdge.D, CubeEdge.E, CubeEdge.H, CubeEdge.G, CubeEdge.H],
	#I
	[CubeEdge.F, CubeEdge.L, CubeEdge.K, CubeEdge.K, CubeEdge.A, CubeEdge.I, CubeEdge.I],
	#J
	[CubeEdge.B, CubeEdge.I, CubeEdge.G, CubeEdge.J, CubeEdge.B, CubeEdge.L, CubeEdge.J],
	#K
	[CubeEdge.G, CubeEdge.J, CubeEdge.C, CubeEdge.I, CubeEdge.C, CubeEdge.K, CubeEdge.K],
	#L
	[CubeEdge.J, CubeEdge.K, CubeEdge.H, CubeEdge.L, CubeEdge.D, CubeEdge.J, CubeEdge.L],
]

static var root_mesh_edges = {
	0x0:[],
	0x1:[
		CubeEdge.F, CubeEdge.I, CubeEdge.J
	],
	0x3:[
		CubeEdge.F, CubeEdge.I, CubeEdge.G,
		CubeEdge.G, CubeEdge.I, CubeEdge.K,
	],
	0x6:[
		CubeEdge.A, CubeEdge.F, CubeEdge.B,
		CubeEdge.G, CubeEdge.J, CubeEdge.K,
	],
	0x7:[
		CubeEdge.A, CubeEdge.I, CubeEdge.K,
		CubeEdge.A, CubeEdge.K, CubeEdge.B,
		CubeEdge.B, CubeEdge.K, CubeEdge.G,
	],
	0xf:[
		CubeEdge.A, CubeEdge.I, CubeEdge.C,
		CubeEdge.C, CubeEdge.I, CubeEdge.K,
	],
	0x16:[
		CubeEdge.A, CubeEdge.F, CubeEdge.B,
		CubeEdge.E, CubeEdge.L, CubeEdge.I,
		CubeEdge.G, CubeEdge.J, CubeEdge.K,		
	],
	0x17:[
		CubeEdge.A, CubeEdge.E, CubeEdge.B,
		CubeEdge.B, CubeEdge.E, CubeEdge.G,
		CubeEdge.E, CubeEdge.L, CubeEdge.G,		
		CubeEdge.G, CubeEdge.L, CubeEdge.K,		
	],
	0x18:[
		CubeEdge.B, CubeEdge.G, CubeEdge.C,
		CubeEdge.E, CubeEdge.L, CubeEdge.I,
	],
	0x19:[
		CubeEdge.B, CubeEdge.G, CubeEdge.C,
		CubeEdge.E, CubeEdge.L, CubeEdge.F,
		CubeEdge.F, CubeEdge.L, CubeEdge.J,		
	],
	0x1b:[
		CubeEdge.B, CubeEdge.F, CubeEdge.C,
		CubeEdge.C, CubeEdge.F, CubeEdge.E,
		CubeEdge.C, CubeEdge.E, CubeEdge.L,		
		CubeEdge.C, CubeEdge.L, CubeEdge.K,		
	],
	0x1e:[
		CubeEdge.A, CubeEdge.E, CubeEdge.C,
		CubeEdge.C, CubeEdge.E, CubeEdge.L,
		CubeEdge.C, CubeEdge.L, CubeEdge.K,		
		CubeEdge.F, CubeEdge.J, CubeEdge.I,		
	],
	0x3c:[
		CubeEdge.A, CubeEdge.E, CubeEdge.C,
		CubeEdge.C, CubeEdge.E, CubeEdge.H,
		CubeEdge.F, CubeEdge.G, CubeEdge.I,		
		CubeEdge.G, CubeEdge.K, CubeEdge.I,		
	],
	0x69:[
		CubeEdge.A, CubeEdge.D, CubeEdge.F,
		CubeEdge.C, CubeEdge.D, CubeEdge.H,
		CubeEdge.E, CubeEdge.I, CubeEdge.L,		
		CubeEdge.G, CubeEdge.K, CubeEdge.J,		
	],
}

#static var root_mesh_edges = [
#	#0
#	[],
#	#1
#	[CubeEdge.E, CubeEdge.L, CubeEdge.I],
#	#3
#	[
#		CubeEdge.E, CubeEdge.H, CubeEdge.K,
#		CubeEdge.E, CubeEdge.K, CubeEdge.I,
#	],
#	#6
#	[
#		CubeEdge.A, CubeEdge.D, CubeEdge.C,
#		CubeEdge.H, CubeEdge.K, CubeEdge.L,
#	],
#	#7
#	[
#		CubeEdge.A, CubeEdge.D, CubeEdge.I,
#		CubeEdge.D, CubeEdge.H, CubeEdge.I,
#		CubeEdge.H, CubeEdge.K, CubeEdge.I,		
#	],
#	#f
#	[
#		CubeEdge.A, CubeEdge.C, CubeEdge.K,
#		CubeEdge.A, CubeEdge.K, CubeEdge.I,
#	],
#	#16
#	[
#		CubeEdge.A, CubeEdge.D, CubeEdge.E,
#		CubeEdge.F, CubeEdge.I, CubeEdge.J,
#		CubeEdge.H, CubeEdge.K, CubeEdge.L,		
#	],
#	#17
#	[
#		CubeEdge.A, CubeEdge.D, CubeEdge.F,
#		CubeEdge.D, CubeEdge.H, CubeEdge.F,
#		CubeEdge.F, CubeEdge.H, CubeEdge.J,		
#		CubeEdge.H, CubeEdge.K, CubeEdge.J,		
#	],
#	#18
#	[
#		CubeEdge.C, CubeEdge.H, CubeEdge.D,
#		CubeEdge.F, CubeEdge.I, CubeEdge.J,
#	],
#	#19
#	[
#		CubeEdge.C, CubeEdge.H, CubeEdge.D,
#		CubeEdge.E, CubeEdge.L, CubeEdge.F,
#		CubeEdge.F, CubeEdge.L, CubeEdge.J,		
#	],
#	#1b
#	[
#		CubeEdge.B, CubeEdge.C, CubeEdge.E,
#		CubeEdge.C, CubeEdge.F, CubeEdge.E,
#		CubeEdge.C, CubeEdge.J, CubeEdge.F,		
#		CubeEdge.C, CubeEdge.K, CubeEdge.J,		
#	],
#	#1e
#	[
#		CubeEdge.A, CubeEdge.J, CubeEdge.F,
#		CubeEdge.A, CubeEdge.C, CubeEdge.J,
#		CubeEdge.C, CubeEdge.K, CubeEdge.J,		
#		CubeEdge.E, CubeEdge.I, CubeEdge.L,		
#	],
#	#3c
#	[
#		CubeEdge.A, CubeEdge.C, CubeEdge.F,
#		CubeEdge.C, CubeEdge.G, CubeEdge.F,
#		CubeEdge.E, CubeEdge.I, CubeEdge.H,		
#		CubeEdge.H, CubeEdge.I, CubeEdge.K,		
#	],
#	#69
#	[
#		CubeEdge.A, CubeEdge.E, CubeEdge.D,
#		CubeEdge.B, CubeEdge.C, CubeEdge.G,
#		CubeEdge.F, CubeEdge.J, CubeEdge.I,		
#		CubeEdge.H, CubeEdge.I, CubeEdge.K,		
#	],
#]

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
				Operations.INVERT:
					count += 1
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

			

static func operate_on_edge(edge:CubeEdge, op:Operations)->CubeEdge:
	return edge_op_table[edge][op]

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
		Operations.INVERT:
			return bits_to_int(!p000, !p100, !p010, !p110, !p001, !p101, !p011, !p111)
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
			Operations.INVERT:
				strn += "in"
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
	
static func print_table(colorings:Array[PeerColoring]):
	
	for coloring in colorings:
		if !coloring.prev:
			#Root coloring
			print("Root coloring: %x" % [coloring.coloring])
		
	colorings.sort_custom(func(a:PeerColoring, b:PeerColoring): return a.coloring < b.coloring)
	for coloring in colorings:
		print("Coloring: %02x  Source: %02x  Xform: %s  Rev Winding: %s Ops: %s " % [coloring.coloring, coloring.get_root_coloring().coloring, str(coloring.calc_tranform()), coloring.reverse_winding(), format_op_list(coloring.operations)])

			
static func format_table_as_code(colorings:Array[PeerColoring])->String:
	colorings.sort_custom(func(a:PeerColoring, b:PeerColoring): return a.coloring < b.coloring)

	var result:String = ""
	
	for c_idx in colorings.size():
		var coloring:PeerColoring = colorings[c_idx]
		var root_col:int = coloring.get_root_coloring().coloring
		var edge_tri_list = root_mesh_edges[root_col]
		
		result += "\t[ # %02x (root %02x, rev winding %s)\n" % [c_idx, root_col, coloring.reverse_winding()]
		
		for i in range(0, edge_tri_list.size(), 3):
			var a:CubeEdge
			var b:CubeEdge
			var c:CubeEdge
			
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
				
			result += "\t\tCubeSymmetries.CubeEdge.%s, CubeSymmetries.CubeEdge.%s, CubeSymmetries.CubeEdge.%s, \n" % [CubeEdge.keys()[a], CubeEdge.keys()[b], CubeEdge.keys()[c]]

		result += "\t],\n"
		
	return result

