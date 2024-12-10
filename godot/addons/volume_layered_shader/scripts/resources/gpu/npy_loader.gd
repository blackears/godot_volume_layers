# MIT License
#
# Copyright (c) 2023 Mark McKay
# https://github.com/blackears/godot_volume_layers
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

@tool
extends Resource
class_name NpyLoader

var size_x:int = 1
var size_y:int = 1
var size_z:int = 1
var size_w:int = 1
var valid:bool = false
var after_header:int
var f:FileAccess
var descr:String

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

func write_to_buffer(buf:PackedByteArray, value:float, offset:int, descr:String)->void:
	match descr:
		"<i1":
			buf.encode_s8(offset * 1, value)
			return
		"<i2":
			buf.encode_s16(offset * 2, value)
			return
		"<i4":
			buf.encode_s32(offset * 4, value)
			return
		"<i8":
			buf.encode_s64(offset * 8, value)
			return
		"<f2":
			buf.encode_half(offset * 2, value)
			return
		"<f4":
			buf.encode_float(offset * 4, value)
			return
		"<f8":
			buf.encode_double(offset * 8, value)
			return
		_:
			buf.encode_u8(offset * 1, value)
			return

func load_file(file_path:String):
	if !FileAccess.file_exists(file_path):
		valid = false
		return
	
	f = FileAccess.open(file_path, FileAccess.READ)
	var magic_buf = f.get_buffer(6)
	var magic_number = magic_buf.get_string_from_ascii()
	if magic_number != "\u0093NUMPY":
		valid = false
		return

	var major_version:int = f.get_8()
	var minor_version:int = f.get_8()

	var header_length:int = f.get_16()
	after_header = round_up_to_64(10 + header_length)
	
	var header_buf:PackedByteArray = f.get_buffer(header_length)
	
	var header_text:String
	if major_version <= 2:
		header_text = header_buf.get_string_from_ascii()
	else:
		header_text = header_buf.get_string_from_utf8()
		
#	print(header_text)
	header_text = header_text.replace("'", "\"")
	header_text = header_text.replace("True", "true")
	header_text = header_text.replace("False", "false")
	header_text = header_text.replace("(", "[")
	header_text = header_text.replace(")", "]")
	
	var json:JSON = JSON.new()
	var err = json.parse(header_text)
	if err == OK:
		var header_dict = json.data
	
		descr = header_dict["descr"]
		var fortran_order:bool = header_dict["fortran_order"]
		var shape = header_dict["shape"]
	
		f.big_endian = fortran_order

		size_x = 1 if shape.size() < 1 else shape[shape.size() - 1]
		size_y = 1 if shape.size() < 2 else shape[shape.size() - 2]
		size_z = 1 if shape.size() < 3 else shape[shape.size() - 3]
		size_w = 1 if shape.size() < 4 else shape[shape.size() - 4]
		

func load_image_stack(frame:int)->Array[Image]:
	var cur_frame:int = clamp(frame, 0, size_w - 1)
	var byte_size:int = get_byte_size(descr)
	
	var image_stack:Array[Image]
	
	f.seek(after_header + byte_size * cur_frame * size_x * size_y * size_z)
	for k in size_z:
		var image_data:PackedFloat32Array
		image_data.resize(size_x * size_y)
		
		for j in size_y:
			for i in size_x:
				var value:float = read_next_value(f, descr)
				#write_to_buffer(image_data, value, j * size_x + i, descr)
				image_data[j * size_x + i] = value

		var img:Image = Image.create_from_data(size_x, size_y, false, Image.FORMAT_RF, image_data.to_byte_array())
		image_stack.append(img)
	
	
	return image_stack
	
