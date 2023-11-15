@tool
extends ImageTexture3D
class_name ZippedImageArchiveTexture3D

@export_file("*.zip") var zip_file:String:
	get:
		return zip_file
	set(value):
		if value == zip_file:
			return
		zip_file = value
		load_image_from_zip(zip_file)


func load_image_from_zip(path:String):
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
				img_width = cur_width
				img_height = cur_height
				img_format = cur_format
				img_list.append(image)
	
	reader.close()

	create(img_format, img_width, img_height, img_list.size(), false, img_list)
#	create(Image.FORMAT_RF, img_width, img_height, img_list.size(), true, img_list)
	
#	var tex:ImageTexture3D = ImageTexture3D.new()
#	tex.create(Image.FORMAT_RF, img_width, img_height, img_list.size(), true, img_list)
#	return tex
	
