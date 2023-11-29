@tool
extends Control

signal updated

@export var mesh:ArrayMesh:
	get:
		return mesh
	set(value):
		if (value == mesh):
			return
		mesh = value
		dirty = true

var dirty:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dirty:
		%mesh.mesh = mesh
		updated.emit()
		
		dirty = false
	pass
	
func export_gltf():
	#Export
	var doc:GLTFDocument = GLTFDocument.new()
	var state:GLTFState = GLTFState.new()

#	doc.append_from_scene(%mesh, state)
	doc.append_from_scene($SubViewportContainer/SubViewport/Node3D, state)
	doc.write_to_filesystem(state, "../export/mesh.glb")
	
#	var root:Node = plugin.get_editor_interface().get_edited_scene_root()
#	var root_clean:Node3D = clean_flat(root) if %check_flatten.button_pressed else clean_branch(root)
#
#	doc.append_from_scene(root_clean, state)
#	doc.write_to_filesystem(state, path)
	
