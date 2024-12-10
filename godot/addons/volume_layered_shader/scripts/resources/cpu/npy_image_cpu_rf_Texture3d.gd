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
extends ImageTexture3D
class_name NpyImageCpuRFTexture3D

@export_file("*.npy") var file_path:String:
	set(value):
		file_path = value
		reload_file()

@export var frame:int = 0:
	set(value):
		frame = value
		reload_file()

func _validate_property(property : Dictionary):
	#Do not write image data to resource file
	if property.name == "_images":
		property.usage = PROPERTY_USAGE_NONE

func reload_file():
	var loader:NpyLoader = NpyLoader.new()
	loader.load_file(file_path)
	
	var img_list:Array[Image] = loader.load_image_stack(frame)
	var size:Vector3i = Vector3i(loader.size_x, loader.size_y, loader.size_z)

	#Generate mipmaps
	#var rd:RenderingDevice = RenderingServer.create_local_rendering_device()
	#var gen:MipmapGenerator_rf_3d = MipmapGenerator_rf_3d.new(rd)
	#var mipmap_images:Array[Image] = gen.calculate(img_list)

	create(Image.FORMAT_RF, size.x, size.y, size.z, false, img_list)
	
	changed.emit()
