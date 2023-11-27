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
class_name GLSLShader

# Due to the bug https://github.com/godotengine/godot/issues/31166, this
# wil not be automatically cleaned up with it does out of scope.  Call
# dispose() manually when you're finished using this resource for now.

var rid:RID
var context:GLSLContext
var mutex:Mutex = Mutex.new()

func _init(context:GLSLContext, rid:RID):
	self.rid = rid
	self.context = context
	#notification.

func is_valid()->bool:
	return rid.is_valid()

func dispose():
	mutex.lock()
	
	if rid.is_valid():
		context.rd.free_rid(rid)
		rid = RID()
	
	mutex.unlock()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		# TODO: Uncomment dispose() call when this bug is fixed
		# https://github.com/godotengine/godot/issues/31166
		#dispose()
		pass
		
