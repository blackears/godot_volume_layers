@tool
extends Control
class_name ImageStackViewer

@export var image_list:Array[Image]:
	get:
		return image_list
	set(value):
		image_list = value
		update_ui()

func update_ui():
	%spin_cur_image.max_value = image_list.size() - 1
	%spin_cur_image.value = min(%spin_cur_image.value, image_list.size())
	if image_list.is_empty():
		%img_texture.custom_minimum_size = Vector2.ZERO
	else:
		%img_texture.custom_minimum_size = image_list[0].get_size()
	
	var img_idx:int = %spin_cur_image.value
	var tex = null if image_list.is_empty() else image_list[img_idx]
	%img_texture.texture = ImageTexture.create_from_image(tex)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_spin_cur_image_value_changed(value:float):
	var img_idx:int = %spin_cur_image.value
	var tex = null if image_list.is_empty() else image_list[img_idx]
	%img_texture.texture = ImageTexture.create_from_image(tex)
#	if image_list.is_empty():
#		%img_texture.size = Vector2.ZERO
#	else:
#		%img_texture.size = image_list[0].get_size()
