# MIT License
#
# Copyright (c) 2023 Mark McKay
# https://github.com/blackears/mri_marching_cubes
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

# This code precomputes the table for cube symmetries.   
#
# Since meny of the different arrangements of cube conrer colorings are rotations, reflections or
# inversions of each other, you can reduce the number of meshes that need to be calculated by
# finding which colorings are related via a set of these simple operations.  This script
# calculates the minimal set of root colorings needed, as well as the transforms needed to
# transform any of the 256 possibilites into one of the root forms.

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

