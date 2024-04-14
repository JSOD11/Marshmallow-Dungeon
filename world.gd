extends Node2D

@onready var levelComplete = %LevelComplete
@onready var endDoor = $EndDoor

var levelPath
var deltaTracker = 0.0

func _ready():
	Events.levelComplete.connect(showLevelComplete)
	Events.endDoorLeft.connect(showEndDoorLeft)
	Events.endDoorRight.connect(showEndDoorRight)

func _process(_delta):
	if CharacterData.gameBeaten:
		deltaTracker += 1
		if deltaTracker == 6:
			showTime()
			deltaTracker = 0

func showTime():
	var currentTime = int(GameTimer.get_elapsed_time())
	@warning_ignore("integer_division")
	var minutes = currentTime / 60
	var seconds = int(currentTime) % 60
	%GameTimeLabel.text = "%02d:%02d" % [minutes, seconds]

func showEndDoorLeft():
	SoundManager.playSound(preload("res://door.wav"))
	endDoor.rotation_degrees = 180
	endDoor.position.y += 16
	endDoor.position.x += 5
	endDoor.show()
	
func showEndDoorRight():
	SoundManager.playSound(preload("res://door.wav"))
	endDoor.show()

func showLevelComplete():
	levelComplete.show()
	get_tree().paused = true
	await LevelTransition.fadeToBlack()
	Events.currentLevel += 1
	levelPath = "res://level_" + str(Events.currentLevel) + ".tscn"
	get_tree().paused = false
	if ResourceLoader.exists(levelPath):
		get_tree().change_scene_to_file.bind(levelPath).call_deferred()
	else:
		get_tree().change_scene_to_file.bind("res://victory_menu.tscn").call_deferred()
	LevelTransition.fadeFromBlack()
