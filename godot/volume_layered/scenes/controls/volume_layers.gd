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

@export var gradient:GradientTexture1D:
	get:
		return gradient
	set(value):
		if value == gradient:
			return
		gradient = value
		rebuild_layers = true

var rebuild_layers:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rebuild_layers:
		var x:float = texture.get_width()
		var y:float = texture.get_height()
		var z:float = texture.get_depth()
		
		#print("texture.get_width()  ", Vector3i(x, y, z))
		
		var basis:Basis = Basis.IDENTITY
		basis = basis * Basis.from_euler(Vector3(deg_to_rad(90), 0, 0))
		basis = basis * Basis.from_scale(Vector3(x, y, z) / min(x, y, z))
		%mesh.transform = Transform3D(basis)
		
		var mat:ShaderMaterial = %mesh.get_surface_override_material(0)
		mat.set_shader_parameter("texture_volume", texture)
		mat.set_shader_parameter("layers", num_layers)
		mat.set_shader_parameter("opacity", opacity)
		mat.set_shader_parameter("gradient", gradient)
		
		#create_layers()
		rebuild_layers = false
	pass
