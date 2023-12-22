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
class_name ZippedImageArchive_RF_3D

signal zipfile_changed

@export_file("*.zip") var zip_file:String:
	get:
		return zip_file
		
	set(value):
		if value == zip_file:
			return
			
		zip_file = value
		dirty = true
		zipfile_changed.emit()

var supported_image_file_formats:Array[String] = [
	"bmp",
	"dds",
	"exr",
	"hdr",
	"jpg",
	"jpeg",
	"png",
	"tga",
	"svg",
	"webp"
]

var img_list:Array[Image]
var img_size:Vector3i
var dirty:bool = true

func get_size()->Vector3i:
	if dirty:
		read_images_from_zip(zip_file)
		dirty = false
	return img_size

func get_image_list()->Array[Image]:
	if dirty:
		read_images_from_zip(zip_file)
		dirty = false
	return img_list

func read_images_from_zip(path:String):
	img_list.clear()
	img_size = Vector3i.ZERO
	if path.is_empty():
		return
		
	var reader:ZIPReader = ZIPReader.new()
	var err := reader.open(path)
	if err != OK:
		return
	
	var img_width:int = -1
	var img_height:int = -1
#	var img_format:int = Image.FORMAT_RGBA8
	var img_format:int = Image.FORMAT_RF
	img_list.clear()
	
	for filename in reader.get_files():
		var suffix:String = filename.get_extension()
		if supported_image_file_formats.has(suffix):
			var buf:PackedByteArray = reader.read_file(filename)
			
			var image:Image = Image.new()
			image.load_png_from_buffer(buf)
			var cur_width:int = image.get_width()
			var cur_height:int = image.get_height()
			var cur_format:int = image.get_format()
			if cur_format != img_format:
				image.convert(img_format)
			
			if img_width == -1 || (img_width == cur_width && img_height == cur_height):
				img_width = cur_width
				img_height = cur_height
				img_list.append(image)
	
	reader.close()
	
	var img_depth:int = img_list.size()
	img_size = Vector3i(img_width, img_height, img_depth)

#	var rd:RenderingDevice = RenderingServer.create_local_rendering_device()
#	var gen:MipmapGenerator_rf_3d = MipmapGenerator_rf_3d.new(rd)
#	var mipmap_images:Array[Image] = gen.calculate(img_list)
#
#	img_list.append_array(mipmap_images)
