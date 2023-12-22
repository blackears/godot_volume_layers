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
class_name TrackballTumbler

@export var focus:Vector3

var mouse_down_pos:Vector2
#var dragging:bool = false
enum DragStyle { NONE, TUMBLE, PAN }
var drag_style:DragStyle = DragStyle.NONE

var yaw_start:float
var pitch_start:float
var zoom_amount:float = .2

func calc_pitch_yaw(pos:Vector3, focus_point:Vector3):
	var offset:Vector3 = pos - focus_point
	#var perp:Vector3 = offset.cross(Vector3.UP)
	
	var pitch = offset.angle_to(Vector3.UP)
	var proj_y:Vector3 = offset.project(Vector3.UP)
	var proj_xz:Vector3 = offset - proj_y
	var yaw = atan2(proj_xz.z, proj_xz.x)
	
	return {"pitch":pitch, "yaw":yaw}
	

func _unhandled_input(event):
	#print(event)
	if false:	
		if event.is_action("move_up"):
			position += basis.y
			focus += basis.y
			get_viewport().set_input_as_handled()
		elif event.is_action("move_down"):
			position += -basis.y
			focus += -basis.y
			get_viewport().set_input_as_handled()
		elif event.is_action("move_left"):
			position += -basis.x
			focus += -basis.x
			get_viewport().set_input_as_handled()
		elif event.is_action("move_right"):
			position += basis.x
			focus += basis.x
			get_viewport().set_input_as_handled()
		elif event.is_action("move_forward"):
			position += -basis.z
			focus += -basis.z
			get_viewport().set_input_as_handled()
		elif event.is_action("move_backward"):
			position += basis.z
			focus += basis.z
			get_viewport().set_input_as_handled()
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				var len:float = global_position.distance_to(focus)

				var new_len:float = len - zoom_amount
				var offset:Vector3 = global_position - focus
				var new_offset:Vector3 = offset.normalized() * new_len
				global_position = focus + new_offset
				look_at(focus)

			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				var len:float = global_position.distance_to(focus)

				var new_len:float = len + zoom_amount
				var offset:Vector3 = global_position - focus
				var new_offset:Vector3 = offset.normalized() * new_len
				global_position = focus + new_offset
				look_at(focus)
			
			else:
				mouse_down_pos = event.position
				var result = calc_pitch_yaw(global_position, focus)
				pitch_start = result["pitch"]
				yaw_start = result["yaw"]
				if event.shift_pressed:
					drag_style = DragStyle.PAN
				else:
					drag_style = DragStyle.TUMBLE
				
		else:
			drag_style = DragStyle.NONE


	elif event is InputEventMouseMotion:
		if drag_style == DragStyle.TUMBLE:
			var offset:Vector2 = event.position - mouse_down_pos

			var len:float = global_position.distance_to(focus)
			var pitch_cur = clamp(pitch_start - offset.y * .01, - 0 / 2+ .01, PI - .01)
			var yaw_cur = yaw_start + offset.x * .01

			var proj_y_len:float = cos(pitch_cur)
			var proj_xz_len:float = sqrt(1 - proj_y_len * proj_y_len)

			var new_pos:Vector3 = Vector3(cos(yaw_cur) * proj_xz_len, proj_y_len, sin(yaw_cur) * proj_xz_len) * len

			global_position = focus + new_pos
			look_at(focus)

		if drag_style == DragStyle.PAN:
			pass



# Called when the node enters the scene tree for the first time.
func _ready():
	calc_pitch_yaw(global_position, focus)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
