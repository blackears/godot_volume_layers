extends Node

var mutex:Mutex = Mutex.new()
var thread:Thread
var rd:RenderingDevice

# Called when the node enters the scene tree for the first time.
func _ready():
	thread = thread.new()
	thread.start(main_loop)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_job():
	mutex.lock()
	mutex.unlock()

func main_loop():
	pass
