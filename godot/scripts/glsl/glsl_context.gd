@tool
extends RefCounted
class_name GLSLContext

var rd:RenderingDevice

func _init():
	rd = RenderingServer.create_local_rendering_device()

## Loads and compiles shader at given path.  
##
## @path: Source path of the shader
## @return: Object encapsulating shader, or null if there was an error
## in loading or compiling.
func load_shader_from_path(path:String)->GLSLShader:
	var shader_file:RDShaderFile = load(path)
	return load_shader(shader_file)
	
func load_shader(shader_file:RDShaderFile)->GLSLShader:
	if !shader_file.base_error.is_empty():
		push_error("Error loading shader", "Invalid code")
		print(shader_file.base_error)
		return null

	var shader_spirv:RDShaderSPIRV = shader_file.get_spirv()
	if !shader_spirv.compile_error_compute.is_empty():
		push_error("Error compiling shader", "Invalid code")
		print(shader_spirv.compile_error_compute)
		return null
	
	var shader_rid:RID = rd.shader_create_from_spirv(shader_spirv)
	return GLSLShader.new(self, shader_rid)
