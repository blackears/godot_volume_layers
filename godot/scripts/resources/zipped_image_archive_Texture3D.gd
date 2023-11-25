@tool
extends ImageTexture3D
class_name ZippedImageArchiveTexture3D

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
	var img_list:Array[Image] = archive.get_image_list()
	var size:Vector3i = archive.get_size()
#	var img_width:int = img_list[0].get_width()
#	var img_height:int = img_list[0].get_height()
#	var img_depth:int = img_list.size()
	create(Image.FORMAT_RF, size.x, size.y, size.z, true, img_list)
	

