extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	var colorings:Array[CubeSymmetries.PeerColoring] = CubeSymmetries.find_all_groups()
	CubeSymmetries.print_root_colors(colorings)
	
#	var text:String = CubeSymmetries.format_table_as_code(colorings)
#	print(text)
	pass # Replace with function body.


func _on_bn_generate_code_gdscript_pressed():
	var colorings:Array[CubeSymmetries.PeerColoring] = CubeSymmetries.find_all_groups()
	var code:String = CubeSymmetries.format_table_as_code(colorings)
	
	var file:FileAccess = FileAccess.open("cube_code.txt", FileAccess.WRITE)
	file.store_string(code)
	
	#print(code)
