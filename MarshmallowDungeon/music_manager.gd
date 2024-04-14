extends Node

var musicPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(musicPlayer)
	musicPlayer.process_mode = Node.PROCESS_MODE_ALWAYS

func playMusic(stream):
	if musicPlayer.stream != stream:
		musicPlayer.stream = stream
		musicPlayer.play()
