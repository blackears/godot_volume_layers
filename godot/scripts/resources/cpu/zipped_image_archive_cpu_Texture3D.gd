@tool
extends ImageTexture3D
class_name ZippedImageArchiveCpuTexture3D

@export_file("*.zip") var zip_file:String:
	get:
		return zip_file
	set(value):
		if value == zip_file:
			return
		zip_file = value
		load_image_from_zip(zip_file)

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
	#print("num images ", img_list.size())
	
	reader.close()
	
	add_mipmaps(img_width, img_height, img_list.size(), img_format, img_list, img_list)

#	for i in img_list.size():
#		print("img %d %d %d" % [i, img_list[i].get_width(), img_list[i].get_height()])

	create(img_format, img_width, img_height, img_depth, true, img_list)

