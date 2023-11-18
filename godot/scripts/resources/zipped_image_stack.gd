@tool
extends Resource
class_name ZippedImageStack

@export_file("*.zip") var zip_file:String:
	get:
		return zip_file
	set(value):
		if value == zip_file:
			return
		zip_file = value
		load_image_from_zip(zip_file)

var data:PackedFloat32Array
var data_size:Vector3i


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
				#print("loading image ", img_list.size())
				img_width = cur_width
				img_height = cur_height
				img_format = cur_format
				img_list.append(image)
				
	var img_depth:int = img_list.size()
	
	reader.close()
	
	#Store data
	data.clear()
	data_size = Vector3i(img_width, img_height, img_list.size())
	
	for img in img_list:
		for y in img_height:
			for x in img_width:
				var col:Color = img.get_pixel(x, y)
				data.append(col.r)

func get_cell_value(pos:Vector3i)->float:
	if pos.x < 0 || pos.x >= data_size.x \
		|| pos.y < 0 || pos.y >= data_size.y \
		|| pos.z < 0 || pos.z >= data_size.z:
		return 0
	return data[((pos.z * data_size.y) + pos.y) * data_size.x + pos.x]
		
		
		
		
