@tool
extends Resource
class_name ImageGradient

var gradients:Array[Vector3]
#var gradients:PackedVector3Array
var size:Vector3i

func get_gradient(pos:Vector3)->Vector3:
	if pos.x < 0 || pos.x >= size.x \
		|| pos.y < 0 || pos.y >= size.y \
		|| pos.z < 0 || pos.z >= size.z:
		return Vector3.ZERO
	
	var idx:int = int(pos.x) + size.x * (int(pos.y) + size.y * int(pos.z))
	return gradients[idx]

