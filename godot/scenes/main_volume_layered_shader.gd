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

extends Node3D

@export_file("*.zip") var source_images:String

func add_mipmaps(img_width:int, img_height:int, img_depth:int, img_format:int, parent_images:Array[Image], img_list:Array[Image]):
	
	if img_width == 1 && img_height == 1 && img_depth == 1:
		return
	
	var mip_width:int = max(1, img_width >> 1)
	var mip_height:int = max(1, img_height >> 1)
	var mip_depth:int = max(1, img_depth >> 1)
	
	var mip_images:Array[Image]
	
	for z_idx in mip_depth:
		var image:Image = Image.create(mip_width, mip_height, false, img_format)
		
		img_list.append(image)
		mip_images.append(image)
		
		#print("adding mip idx %d w %d h %d img_depth %d" % [img_list.size(), mip_width, mip_height, img_depth])
		
		for y_idx in mip_height:
			for x_idx in mip_width:
				var color:Color

				for zz in 2:
					var src_image:Image = parent_images[min(z_idx * 2 + zz, img_depth - 1)]

					for yy in 2:
						for xx in 2:
							color += src_image.get_pixel(min(x_idx * 2 + xx, img_width - 1), min(y_idx * 2 + yy, img_height - 1))

				color /= 8
				image.set_pixel(x_idx, y_idx, color)
		
	add_mipmaps(mip_width, mip_height, mip_depth, img_format, mip_images, img_list)



func load_image_from_zip(path:String)->Texture3D:
	var reader:ZIPReader = ZIPReader.new()
	var err := reader.open(path)
	if err != OK:
		return null
	
	var img_width:int = -1
	var img_height:int = -1
	var img_format:int
	var img_list:Array[Image]
	
	for filename in reader.get_files():
		if filename.ends_with(".png"):
			var buf:PackedByteArray = reader.read_file(filename)
			
			var image:Image = Image.new()
			image.load_png_from_buffer(buf)
			var cur_width:int = image.get_width()
			var cur_height:int = image.get_height()
			var cur_format:int = image.get_format()
			
			if img_width == -1 || (img_width == cur_width && img_height == cur_height && img_format == cur_format):
				print("loading image ", img_list.size())
				img_width = cur_width
				img_height = cur_height
				img_format = cur_format
				img_list.append(image)
				
				#break
	
	var img_depth:int = img_list.size()
	print("num images ", img_list.size())
	
	reader.close()
	
	add_mipmaps(img_width, img_height, img_list.size(), img_format, img_list, img_list)

#	for i in img_list.size():
#		print("img %d %d %d" % [i, img_list[i].get_width(), img_list[i].get_height()])

	var tex:ImageTexture3D = ImageTexture3D.new()
	tex.create(img_format, img_width, img_height, img_depth, true, img_list)
#	tex.create(img_format, img_width, img_height, img_depth, false, img_list)
	return tex

# Called when the node enters the scene tree for the first time.
func _ready():
	%slider_gamma.value = %VolumeLayeredShader.gamma
	%spin_num_layers.value = %VolumeLayeredShader.num_layers
	
	var tex = %VolumeLayeredShader.texture
	if tex && "frame" in tex:
		%spin_frame.value = tex.frame
		
	
	pass # Replace with function body.




func _on_bn_load_pressed():
	%popup_load_file.popup_centered()


func _on_popup_load_file_file_selected(path:String):
	if !FileAccess.file_exists(path):
		return
	
	if path.ends_with(".npy"):
		var tex:NpyImageCpuRFTexture3D = NpyImageCpuRFTexture3D.new()
		tex.file_path = path
		tex.frame = %spin_frame.value
		
		%VolumeLayeredShader.texture = tex
	
	elif path.ends_with(".zip"):
		var tex:ZippedImageArchiveCpuTexture3D = ZippedImageArchiveCpuTexture3D.new()
		tex.zip_file = path
	
	#var archive:ZippedImageArchive_RF_3D = ZippedImageArchive_RF_3D.new()
	#archive.zip_file = path
	#
	#var tex:ZippedImageArchiveRFTexture3D = ZippedImageArchiveRFTexture3D.new()
	#tex.archive = archive
	
		%VolumeLayeredShader.texture = tex



func _on_slider_gamma_value_changed(value):
	%VolumeLayeredShader.gamma = value


func _on_spin_num_layers_value_changed(value):
	%VolumeLayeredShader.num_layers = value


func _on_spin_frame_value_changed(value: float) -> void:
	var tex = %VolumeLayeredShader.texture
	if tex && "frame" in tex:
		tex.frame = value

var playing:bool = false
var time_since_last_frame:float = 0

func _on_bn_play_pressed() -> void:
	playing = true
	pass # Replace with function body.


func _on_bn_stop_pressed() -> void:
	playing = false
	pass # Replace with function body.


func _on_check_loop_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.

func _process(_delta):
	if playing:
		time_since_last_frame += _delta
		
		var sec_per_frame:float = 1.0 / %spin_fps.value
		if time_since_last_frame > sec_per_frame:
			time_since_last_frame = 0
			
			var frame:int = %spin_frame.value
			frame += 1

			var tex = %VolumeLayeredShader.texture
			
			if "max_frames" in tex:
				frame = wrap(frame, 0, tex.max_frames)
			
			if "frame" in tex:
				tex.frame = frame
			
			%spin_frame.value = frame
		
	pass
