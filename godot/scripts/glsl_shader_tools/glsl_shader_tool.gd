@tool
extends RefCounted
class_name GLSLShaderTool

var rd:RenderingDevice

func _init(rd:RenderingDevice):
	self.rd = rd
	
