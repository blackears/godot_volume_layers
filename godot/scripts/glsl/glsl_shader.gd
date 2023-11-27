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
		
