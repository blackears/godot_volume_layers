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

func load_image_from_archive(archive:ZippedImageArchive_RF_3D):
	var img_list:Array[Image] = archive.get_image_list().duplicate()
	var size:Vector3i = archive.get_size()
	print("tex3d num img " + str(img_list.size()))

	#Generate mipmaps
	var rd:RenderingDevice = RenderingServer.create_local_rendering_device()
	var gen:MipmapGenerator_rf_3d = MipmapGenerator_rf_3d.new(rd)
	var mipmap_images:Array[Image] = gen.calculate(img_list)
	
	img_list.append_array(mipmap_images)

	create(Image.FORMAT_RF, size.x, size.y, size.z, true, img_list)
	

