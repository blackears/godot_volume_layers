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

@tool
extends Node3D
class_name VolumeLayers

@export var texture:Texture3D:
	get:
		return texture
	set(value):
		if texture == value:
			return
		texture = value
		rebuild_layers = true


@export var num_layers:int = 10:
	get:
		return num_layers
	set(value):
		if value == num_layers:
			return
		num_layers = value
		rebuild_layers = true

@export var opacity:float = 1:
	get:
		return opacity
	set(value):
		if value == opacity:
			return
		opacity = value
		rebuild_layers = true

@export var gradient:GradientTexture1D = preload("res://addons/textures/purple_gradient_texture.tres"):
	get:
		return gradient
	set(value):
		if value == gradient:
			return
		gradient = value
		rebuild_layers = true

var rebuild_layers:bool = true
var mesh_inst:MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh_inst = MeshInstance3D.new()
	add_child(mesh_inst)
	
	var mesh:BoxMesh = BoxMesh.new()
	mesh.flip_faces = true
	mesh_inst.mesh = mesh
	
	var mat:Material = preload("res://addons/volume_layered_shader/materials/volume_layered_shader.tres").duplicate()
	mesh_inst.set_surface_override_material(0, mat)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rebuild_layers:
		if !texture:
			return
		
		var x:float = texture.get_width()
		var y:float = texture.get_height()
		var z:float = texture.get_depth()
		
		#print("texture.get_width()  ", Vector3i(x, y, z))
		
		var basis:Basis = Basis.IDENTITY
		basis = basis * Basis.from_euler(Vector3(deg_to_rad(-90), 0, 0))
		basis = basis * Basis.from_scale(Vector3(x, y, z) / min(x, y, z))
		mesh_inst.transform = Transform3D(basis)
		
		var mat:ShaderMaterial = mesh_inst.get_surface_override_material(0)
		mat.set_shader_parameter("texture_volume", texture)
		mat.set_shader_parameter("layers", num_layers)
		mat.set_shader_parameter("opacity", opacity)
		mat.set_shader_parameter("gradient", gradient)
		
		#create_layers()
		rebuild_layers = false
	pass
