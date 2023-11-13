extends RefCounted
class_name MarchingCubes


class CubeTransform extends RefCounted:
	var root_coloring:int
	var transform:Transform3D
	var reverse_winding:bool
	
	func _init(root_coloring:int, transform:Transform3D = Transform3D.IDENTITY, reverse_winding:bool = false):
		self.root_coloring = root_coloring
		self.transform = transform
		self.reverse_winding = reverse_winding

var cube_transform_table:Array[CubeTransform] = [
	CubeTransform.new(0x00, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x06, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x0f, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x06, Transform3D(Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x16, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x17, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x18, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1b, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1e, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x06, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x18, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x17, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x03, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x0f, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x3c, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x06, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x18, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x03, Transform3D(Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x06, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x17, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x0f, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x3c, Transform3D(Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x06, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1e, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x3c, Transform3D(Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x69, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x16, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x17, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x18, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x01, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x01, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x18, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x06, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x06, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x03, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x17, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x69, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x3c, Transform3D(Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x3c, Transform3D(Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x0f, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1b, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x17, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1e, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x18, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x03, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x3c, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x1e, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 1, 0), Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x0f, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x03, Transform3D(Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x17, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x16, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x18, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x06, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1e, Transform3D(Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x19, Transform3D(Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x1b, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x19, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x18, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x17, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x16, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x06, Transform3D(Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x0f, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, -1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x03, Transform3D(Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x07, Transform3D(Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x06, Transform3D(Vector3(1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x07, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x06, Transform3D(Vector3(0, -1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x03, Transform3D(Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, -1, 0), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x03, Transform3D(Vector3(-1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), false),
	CubeTransform.new(0x01, Transform3D(Vector3(0, 1, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x01, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
	CubeTransform.new(0x00, Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), true),
]

class CubeParams extends RefCounted:
	var a_frac:float = .5
	var b_frac:float = .5
	var c_frac:float = .5
	var d_frac:float = .5
	var e_frac:float = .5
	var f_frac:float = .5
	var g_frac:float = .5
	var h_frac:float = .5
	var i_frac:float = .5
	var j_frac:float = .5
	var k_frac:float = .5
	var l_frac:float = .5

func create_root_mesh(coloring:int, cube_params:CubeParams)->PackedVector3Array:
	#Create points based on ratios
	var pa:Vector3 = Vector3(cube_params.a_frac, 1, -1)
	var pb:Vector3 = Vector3(1, 1, cube_params.b_frac)
	var pc:Vector3 = Vector3(cube_params.c_frac, 1, 1)
	var pd:Vector3 = Vector3(-1, 1, cube_params.b_frac)
	
	var pe:Vector3 = Vector3(-1, cube_params.e_frac, -1)
	var pf:Vector3 = Vector3(1, cube_params.f_frac, -1)
	var pg:Vector3 = Vector3(1, cube_params.g_frac, 1)
	var ph:Vector3 = Vector3(-1, cube_params.h_frac, 1)

	var pi:Vector3 = Vector3(cube_params.i_frac, -1, -1)
	var pj:Vector3 = Vector3(1, -1, cube_params.j_frac)
	var pk:Vector3 = Vector3(cube_params.k_frac, -1, 1)
	var pl:Vector3 = Vector3(-1, -1, cube_params.l_frac)
	
	var result:PackedVector3Array
	match(coloring):
		0:
			pass
		1:
			result.append_array([pe, pl, pi])
		3:
			result.append_array([pe, ph, pk])
			result.append_array([pe, pk, pi])
		6:
			result.append_array([pa, pd, pc])
			result.append_array([ph, pk, pl])
		7:
			result.append_array([pa, pd, pi])
			result.append_array([pd, ph, pi])
			result.append_array([ph, pk, pi])
		0xf:
			result.append_array([pa, pc, pk])
			result.append_array([pa, pk, pi])
		0x16:
			result.append_array([pa, pd, pe])
			result.append_array([pf, pi, pj])
			result.append_array([ph, pk, pl])
		0x17:
			result.append_array([pa, pd, pf])
			result.append_array([pd, ph, pf])
			result.append_array([pf, ph, pj])
			result.append_array([ph, pk, pj])
		0x18:
			result.append_array([pc, ph, pd])
			result.append_array([pf, pi, pj])
		0x19:
			result.append_array([pc, ph, pd])
			result.append_array([pe, pl, pf])
			result.append_array([pf, pl, pj])
		0x1b:
			result.append_array([pb, pc, pe])
			result.append_array([pc, pf, pe])
			result.append_array([pc, pj, pf])
			result.append_array([pc, pk, pj])
		0x1e:
			result.append_array([pa, pj, pf])
			result.append_array([pa, pc, pj])
			result.append_array([pc, pk, pj])
			result.append_array([pe, pi, pl])
		0x3c:
			result.append_array([pa, pc, pf])
			result.append_array([pc, pg, pf])
			result.append_array([pe, pi, ph])
			result.append_array([ph, pi, pk])
		0x69:
			result.append_array([pa, pe, pd])
			result.append_array([pb, pc, pg])
			result.append_array([pf, pj, pi])
			result.append_array([ph, pl, pk])
		_:
			assert(false, "Invalid coloring")
	
	return result

func create_cube_mesh(coloring:int, cube_params:CubeParams)->PackedVector3Array:
	var cube_xform:CubeTransform = cube_transform_table[coloring]
	var tris_root:PackedVector3Array = create_root_mesh(cube_xform.root_coloring, cube_params)
	if cube_xform.root_coloring == coloring:
		return tris_root
	
	var result:PackedVector3Array
	for i in range(0, tris_root.size(), 3):
		var pa:Vector3
		var pb:Vector3
		var pc:Vector3
		if cube_xform.reverse_winding:
			pa = tris_root[i]
			pc = tris_root[i + 1]
			pb = tris_root[i + 2]
		else:
			pa = tris_root[i]
			pb = tris_root[i + 1]
			pc = tris_root[i + 2]
		
		pa = cube_xform.transform * pa
		pb = cube_xform.transform * pb
		pc = cube_xform.transform * pc
		result.append(pa)
		result.append(pb)
		result.append(pc)
		
	return result
