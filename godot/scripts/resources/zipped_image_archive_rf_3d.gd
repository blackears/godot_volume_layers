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
		load_image_from_zip(zip_file)
		dirty = false
	return img_size

func get_image_list()->Array[Image]:
	if dirty:
		load_image_from_zip(zip_file)
		dirty = false
	return img_list

func load_image_from_zip(path:String):
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

	var gen:MipmapGenerator_rf_3d = MipmapGenerator_rf_3d.new()
	var mipmap_images:Array[Image] = gen.calculate(img_list)
	
	img_list.append_array(mipmap_images)
	#create(img_format, img_width, img_height, img_depth, true, img_list)
