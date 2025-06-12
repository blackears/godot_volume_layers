extends Control

@export_file("*.npy") var file:String

## code		dtype
## <i2		int16
## <f4		float32
## <f2		float16
## <f8		float64
@export var frame:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_file()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func round_up_to_64(v:int)->int:
	return (((v - 1) / 64) + 1) * 64

func get_byte_size(descr:String)->int:
	match descr:
		"<u1":
			return 1
		"<u2":
			return 2
		"<u4":
			return 4
		"<u8":
			return 8
		"<i1":
			return 1
		"<i2":
			return 2
		"<i4":
			return 4
		"<i8":
			return 8
		"<f2":
			return 2
		"<f4":
			return 4
		"<f8":
			return 8
		_:
			return 1

func read_next_value(f:FileAccess, descr:String)->float:
	match descr:
		"<i1":
			return f.get_8()
		"<i2":
			return f.get_16()
		"<i4":
			return f.get_32()
		"<i8":
			return f.get_64()
		"<f2":
			#Requires Godot 4.4 or later
			return f.get_half()
			#return 2
		"<f4":
			return f.get_float()
		"<f8":
			return f.get_double()
		_:
			return f.get_8()

func load_file():
	if !FileAccess.file_exists(file):
		return
	
	var f:FileAccess = FileAccess.open(file, FileAccess.READ)
	var magic_buf = f.get_buffer(6)
	var magic_number = magic_buf.get_string_from_ascii()
	if magic_number != "\u0093NUMPY":
		return

	var major_version:int = f.get_8()
	var minor_version:int = f.get_8()

	var header_length:int = f.get_16()
	var after_header:int = round_up_to_64(10 + header_length)
	
	var header_buf:PackedByteArray = f.get_buffer(header_length)
	
	var header_text:String
	if major_version <= 2:
		header_text = header_buf.get_string_from_ascii()
	else:
		header_text = header_buf.get_string_from_utf8()
		
	print(header_text)
	header_text = header_text.replace("'", "\"")
	header_text = header_text.replace("True", "true")
	header_text = header_text.replace("False", "false")
	header_text = header_text.replace("(", "[")
	header_text = header_text.replace(")", "]")
	
#	header_text = "{'descr': '<f8', 'fortran_order': False, 'shape': (10, 50, 60, 70), }"
#	header_text = "{'descr': '<f8', 'fortran_order': false, 'shape': [10, 50, 60, 70], }"
	#header_text = "{\"descr\": \"<f8\", \"fortran_order\": false, \"shape\": [10, 50, 60, 70], }"
	#var test_json_dict = {
		#"descr": "<f8",
		#"fortran_order": false,
		#"shape": [10, 50, 60, 70]
		#}
	#var test_strn = JSON.stringify(test_json_dict)
	#print(test_strn)
	
	
	
	var json:JSON = JSON.new()
	var err = json.parse(header_text)
	if err == OK:
		var header_dict = json.data
	
#		var header_dict = JSON.parse_string(header_text)
	
		var descr:String = header_dict["descr"]
		var fortran_order:bool = header_dict["fortran_order"]
		var shape = header_dict["shape"]
	
		f.big_endian = fortran_order
		var byte_size:int = get_byte_size(descr)
		
		var size_x:int = 1
		var size_y:int = 1
		var size_z:int = 1
		var size_w:int = 1
		var cur_frame:int = frame
		
		if shape.size() == 4:
			size_x = shape[3]
			size_y = shape[2]
			size_z = shape[1]
			size_w = shape[0]
			cur_frame = clamp(cur_frame, 0, size_w)
		elif shape.size() == 3:
			size_x = shape[2]
			size_y = shape[1]
			size_z = shape[0]
			cur_frame = 0
		else:
			return
		
		f.seek(after_header + byte_size * cur_frame * size_x * size_y * size_z)
		for k in size_z:
			for j in size_y:
				for i in size_x:
					var value:float = read_next_value(f, descr)
		
		
		print("Scan done")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", header_text, " at line ", json.get_error_line())

		
	pass

func _on_bn_load_file_pressed() -> void:
	load_file()
	pass # Replace with function body.
