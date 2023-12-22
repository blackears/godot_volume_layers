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
class_name ZippedImageArchiveRFTexture3D

@export var archive:ZippedImageArchive_RF_3D:
	get:
		return archive
		
	set(value):
		if value == archive:
			return
		
		if archive:
			archive.zipfile_changed.disconnect(on_archive_changed)
			
		archive = value

		if archive:
			archive.zipfile_changed.connect(on_archive_changed)
			load_image_from_archive(archive)

func on_archive_changed():
	load_image_from_archive(archive)

func _validate_property(property : Dictionary):
	#Do not write image data to resource file
	if property.name == "_images":
		property.usage = PROPERTY_USAGE_NONE
		
func load_image_from_archive(archive:ZippedImageArchive_RF_3D):
	var img_list:Array[Image] = archive.get_image_list().duplicate()
	var size:Vector3i = archive.get_size()
	#print("tex3d num img " + str(img_list.size()))

	#Generate mipmaps
	var rd:RenderingDevice = RenderingServer.create_local_rendering_device()
	var gen:MipmapGenerator_rf_3d = MipmapGenerator_rf_3d.new(rd)
	var mipmap_images:Array[Image] = gen.calculate(img_list)
	
	img_list.append_array(mipmap_images)

	create(Image.FORMAT_RF, size.x, size.y, size.z, true, img_list)
	

