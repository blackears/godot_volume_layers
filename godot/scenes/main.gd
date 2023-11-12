extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
#	var peers = CubeSymmetries.find_peer_colorings(1)
	var peers = CubeSymmetries.find_all_groups()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
