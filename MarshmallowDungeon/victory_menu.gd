extends CenterContainer

@onready var menuButton = %MenuButton
var sceneExited = false

func _ready():
	CharacterData.gameBeaten = true
	var currentTime = int(GameTimer.get_elapsed_time())
	calculateDifficulties(currentTime)
	@warning_ignore("integer_division")
	var minutes = int(currentTime / 60)
	var seconds = int(currentTime % 60)
	$VBoxContainer/TimeLabel.text = "%02d:%02d" % [minutes, seconds]
	Events.currentLevel = 1
	menuButton.grab_focus()

func _on_menu_button_pressed():
	if not sceneExited:
		sceneExited = true
		SoundManager.playSound(preload("res://table_hit.wav"))
		await LevelTransition.fadeToBlack()
		get_tree().change_scene_to_file("res://start_menu.tscn")
		MusicManager.musicPlayer.stop()
		LevelTransition.fadeFromBlack()
	
func calculateDifficulties(t):
	for i in range(len(CharacterData.difficulties)):
		if t <= CharacterData.difficultyTimes[i] * 60:
			CharacterData.difficulties[i] = true
