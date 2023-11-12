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
enum Operations { INVERT, ROT_X_90, ROT_Y_90, ROT_Z_90, MIRROR_X, MIRROR_Y, MIRROR_Z }

class ColorGroup extends RefCounted:
	var tessellation:PackedVector3Array

class PeerColoring extends RefCounted:
	var coloring:int
	var operations:PackedInt32Array
	#var group_id:int
	var prev:PeerColoring

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
static func apply_operation(coloring:int, op:Operations)->int:
	var p000:bool = (coloring & 0x1) != 0
	var p001:bool = (coloring & 0x2) != 0
	var p010:bool = (coloring & 0x4) != 0
	var p011:bool = (coloring & 0x8) != 0
	var p100:bool = (coloring & 0x10) != 0
	var p101:bool = (coloring & 0x20) != 0
	var p110:bool = (coloring & 0x40) != 0
	var p111:bool = (coloring & 0x80) != 0
	
	match op:
		Operations.INVERT:
			return bits_to_int(!p000, !p001, !p010, !p011, !p100, !p101, !p110, !p111)
		Operations.ROT_X_90:
			return bits_to_int(p100, p101, p000, p001, p110, p111, p010, p011)
		Operations.ROT_Y_90:
			return bits_to_int(p001, p101, p011, p111, p000, p100, p010, p110)
		Operations.ROT_Z_90:
			return bits_to_int(p010, p000, p011, p001, p110, p100, p111, p101)
		Operations.MIRROR_X:
			return bits_to_int(p001, p000, p011, p010, p101, p100, p111, p110)
		Operations.MIRROR_Y:
			return bits_to_int(p010, p011, p000, p001, p110, p111, p100, p101)
		Operations.MIRROR_Z:
			return bits_to_int(p100, p101, p110, p111, p000, p001, p010, p011)
			
	assert(false, "Illegal operation")
	return 0
		
static func has_coloring(coloring:int, peer_colorings:Array[PeerColoring])->bool:
	for peer in peer_colorings:
		if peer.coloring == coloring:
			return true
	return false

static func find_peer_colorings_recursive(cur_coloring:PeerColoring, found_colorings:Array[PeerColoring]):

	for op in Operations.size():
		var new_coloring:int = apply_operation(cur_coloring.coloring, op)
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
			start_colorings.append(peer_coloring)
			
			find_peer_colorings_recursive(peer_coloring, found_colorings)
		
	return found_colorings


