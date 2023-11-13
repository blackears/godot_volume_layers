extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
#	var peers = CubeSymmetries.find_peer_colorings(1)
	var peers = CubeSymmetries.find_all_groups()
	
#	CubeSymmetries.print_table(peers)
	var code:String = CubeSymmetries.format_table_as_code(peers)
	var file:FileAccess = FileAccess.open("cube_code.txt", FileAccess.WRITE)
	file.store_string(code)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
