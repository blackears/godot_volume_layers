@tool
extends Node3D

@export var foo:int:
	get:
		return foo
	set(value):
		value = foo
		dirty = true

var dirty:bool = true

func build_mesh():
	var marching_cubes:MarchingCubesBloyd = MarchingCubesBloyd.new()

	var final_points:PackedVector3Array
	var final_norms:PackedVector3Array
	
	for i in 256:
		var corner_weights:Array[float] = [
			0 if (i & 0x1) == 0 else 1,
			0 if (i & 0x2) == 0 else 1,
			0 if (i & 0x4) == 0 else 1,
			0 if (i & 0x8) == 0 else 1,
			0 if (i & 0x10) == 0 else 1,
			0 if (i & 0x20) == 0 else 1,
			0 if (i & 0x40) == 0 else 1,
			0 if (i & 0x80) == 0 else 1,
		]
		
		var points:PackedVector3Array = marching_cubes.generate_mesh(.5, corner_weights)
		
		var xoff:int = i & 0xf
		var zoff:int = i >> 4
		var xform:Transform3D = Transform3D.IDENTITY
		xform = xform.scaled_local(Vector3(.2, .2, .2))
		xform = xform.translated_local(Vector3(xoff, 0, zoff) * 2)
		
		for p_idx in points.size():
			points[p_idx] = xform * points[p_idx]
		
		final_points.append_array(points)
		pass
	
	for i in range(0, final_points.size(), 3):
		var p0:Vector3 = final_points[i]
		var p1:Vector3 = final_points[i + 1]
		var p2:Vector3 = final_points[i + 2]
		
		var norm:Vector3 = -((p1 - p0).cross(p2 - p0)).normalized()

		final_norms.append(norm)
		final_norms.append(norm)
		final_norms.append(norm)

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = final_points
	arrays[Mesh.ARRAY_NORMAL] = final_norms

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	#arr_mesh.surface_set_material(0, material)
	print("Setting points mesh")
	%mesh.mesh = arr_mesh


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dirty:
		build_mesh()
		dirty = false
	pass
