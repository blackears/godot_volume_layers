@tool
extends GLSLShaderTool
class_name MarchingCubesGeneratorGLSL

func _init():
	pass

func dispose():
	pass

# source_grid_size - dimensions of source image data.  Density and gradient image stacks must both be of this size
# result_grid_size - number of cells in result marching cubes mesh
# threshold - surface density threshold
# img_list_density - image stack with 3d density data
# img_list_gradient - image stack with 3d gradient data
func generate_mesh(source_grid_size:Vector3i, result_grid_size:Vector3i, threshold:float, img_list_density:Array[Image], img_list_gradient:Array[Image]):
	pass
