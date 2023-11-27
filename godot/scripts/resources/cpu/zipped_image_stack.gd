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

var gradient:ImageGradient


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
		var suffix:String = filename.get_extension()
		if supported_image_file_formats.has(suffix):
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
	
	var val:float = data[((pos.z * data_size.y) + pos.y) * data_size.x + pos.x]
	return val

func get_gradient(pos:Vector3)->Vector3:
	var dx:float = get_cell_value(pos + Vector3(1, 0, 0)) - get_cell_value(pos + Vector3(-1, 0, 0))
	var dy:float = get_cell_value(pos + Vector3(0, 1, 0)) - get_cell_value(pos + Vector3(0, -1, 0))
	var dz:float = get_cell_value(pos + Vector3(0, 0, 1)) - get_cell_value(pos + Vector3(0, 0, -1))
	
	return Vector3(dx, dy, dz)

func calc_gradients()->ImageGradient:
	if gradient:
		return gradient
	
#	var grad_list:PackedVector3Array
	var grad_list:Array[Vector3]
	
	#Convolve with a simple 3x1 kernel for each dimension
	for k in data_size.z - 1:
		for j in data_size.y - 1:
			for i in data_size.x - 1:
				
				var dx:float = get_cell_value(Vector3i(i + 1, j, k)) - get_cell_value(Vector3i(i - 1, j, k))
				var dy:float = get_cell_value(Vector3i(i, j + 1, k)) - get_cell_value(Vector3i(i, j - 1, k))
				var dz:float = get_cell_value(Vector3i(i, j, k + 1)) - get_cell_value(Vector3i(i, j, k - 1))
				
				var grad:Vector3 = Vector3(dx, dy, dz)
				if !grad.is_zero_approx():
					pass
				grad_list.append(grad)
				
	gradient = ImageGradient.new()
	gradient.gradients = grad_list
	gradient.size = data_size
	return gradient
		
		
