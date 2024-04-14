extends Node

# Signal to emit the time
signal timeUpdated(time)

var deltaTracker = 0.0

var startTime = 0.0
var currentTime = 0.0

func _ready():
	startTime = Time.get_unix_time_from_system()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	deltaTracker += 1
	if deltaTracker == 6:
		currentTime = Time.get_unix_time_from_system() - startTime
		emit_signal("timeUpdated", currentTime)
		deltaTracker = 0

func reset_timer():
	startTime = Time.get_unix_time_from_system()

func get_elapsed_time():
	return currentTime
