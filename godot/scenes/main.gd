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
	
#	var peers = CubeSymmetries.find_peer_colorings(1)
	var peers = CubeSymmetries.find_all_groups()
	
#	CubeSymmetries.print_table(peers)
#	var code:String = CubeSymmetries.format_table_as_code(peers)
#	var file:FileAccess = FileAccess.open("cube_code.txt", FileAccess.WRITE)
#	file.store_string(code)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_bn_load_pressed():
	var tex:Texture3D = load_image_from_zip(source_images)
	print("Loaded")
	pass # Replace with function body.
