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
		
		if texture:
			texture.changed.disconnect(on_texture_changed)
			
		texture = value
		
		if texture:
			texture.changed.connect(on_texture_changed)
		


@export var num_layers:int = 10:
	get:
		return num_layers
	set(value):
		if value == num_layers:
			return
		num_layers = value
		rebuild_layers = true

@export_range(0, 4) var gamma:float = 1:
	get:
		return gamma
	set(value):
		if value == gamma:
			return
		gamma = value
		rebuild_layers = true

@export_range(0, 1) var opacity:float = 1:
	get:
		return opacity
	set(value):
		if value == opacity:
			return
		opacity = value
		rebuild_layers = true

@export_range(0, 4) var color_scalar:float = 1:
	get:
		return color_scalar
	set(value):
		if value == color_scalar:
			return
		color_scalar = value
		rebuild_layers = true

@export var gradient:GradientTexture1D = preload("res://addons/volume_layered_shader/textures/purple_gradient_texture.tres"):
	get:
		return gradient
	set(value):
		if value == gradient:
			return
		gradient = value

@export var exclusion_planes:Array[NodePath]:
	get:
		return exclusion_planes
	set(value):
		if value == exclusion_planes:
			return
		exclusion_planes = value
		rebuild_layers = true


var rebuild_layers:bool = true
var mesh_inst:MeshInstance3D

func on_texture_changed():
	rebuild_layers = true
	

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh_inst = MeshInstance3D.new()
	add_child(mesh_inst)
	
	var mesh:BoxMesh = BoxMesh.new()
#	mesh.flip_faces = true
	mesh.flip_faces = false
	mesh_inst.mesh = mesh
	
	var mat:Material = preload("res://addons/volume_layered_shader/materials/volume_layered_shader.tres").duplicate()
	mesh_inst.set_surface_override_material(0, mat)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print("<0>")
#	if rebuild_layers:
	if !texture:
		return
	
	var x:float = texture.get_width()
	var y:float = texture.get_height()
	var z:float = texture.get_depth()
	
	#print("texture size  ", Vector3i(x, y, z))
	#print("<1>")
	
	var basis:Basis = Basis.IDENTITY
	basis = basis * Basis.from_euler(Vector3(deg_to_rad(-90), 0, 0))
	basis = basis * Basis.from_scale(Vector3(x, y, z) / min(x, y, z))
	mesh_inst.transform = Transform3D(basis)
	
	var mat:ShaderMaterial = mesh_inst.get_surface_override_material(0)
	mat.set_shader_parameter("texture_volume", texture)
	#print("num_layers ", num_layers)
	mat.set_shader_parameter("layers", num_layers)
	mat.set_shader_parameter("opacity", opacity)
	mat.set_shader_parameter("color_scalar", color_scalar)
	mat.set_shader_parameter("gamma", gamma)
	mat.set_shader_parameter("gradient", gradient)
	#print("<2>")
	
	var plane_count:int = 0
	var plane_list:PackedFloat32Array
	for node_path in exclusion_planes:
		var node:Node = get_node(node_path)
		if node is Node3D:
			var xform:Transform3D = (node as Node3D).global_transform
			var p:Plane = Plane(xform.basis.z, xform.origin)
			plane_count += 1
			plane_list.append(p.x)
			plane_list.append(p.y)
			plane_list.append(p.z)
			plane_list.append(p.d)
			
	mat.set_shader_parameter("num_exclusion_planes", plane_count)
	mat.set_shader_parameter("exclusion_planes", plane_list)
	#print("<3>")
		
		#create_layers()
#		rebuild_layers = false

	#if texture:
#
		#var mat:ShaderMaterial = mesh_inst.get_surface_override_material(0)
		#
		#var plane_count:int = 0
		#var plane_list:PackedFloat32Array
		#for node_path in exclusion_planes:
			#var node:Node = get_node(node_path)
			#if node is Node3D:
				#var xform:Transform3D = (node as Node3D).global_transform
				#var p:Plane = Plane(xform.basis.z, xform.origin)
				#plane_count += 1
				#plane_list.append(p.x)
				#plane_list.append(p.y)
				#plane_list.append(p.z)
				#plane_list.append(p.d)
				#
		#mat.set_shader_parameter("num_exclusion_planes", plane_count)
		#mat.set_shader_parameter("exclusion_planes", plane_list)
		
#		print("plane_count ", plane_count)
#		print("plane_list ", plane_list[3])
		
