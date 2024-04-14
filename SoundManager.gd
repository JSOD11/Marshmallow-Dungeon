extends Node

var soundPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(soundPlayer)
	soundPlayer.process_mode = Node.PROCESS_MODE_ALWAYS

func playSound(stream):
	soundPlayer.stream = stream
	soundPlayer.play()
