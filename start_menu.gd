extends CenterContainer

@onready var startButton = %StartGameButton
var sceneExited = false

func _ready():
	MusicManager.playMusic(preload("res://title_music.ogg"))
	RenderingServer.set_default_clear_color(Color.BLACK)
	CharacterData.hearts = 0
	if CharacterData.gameBeaten:
		%AchievementsButton.show()
	startButton.grab_focus()

func _on_start_game_button_pressed():
	if not sceneExited:
		sceneExited = true
		$ButtonPressedSound.play()
		await LevelTransition.fadeToBlack()
		get_tree().change_scene_to_file("res://level_1.tscn")
		GameTimer.reset_timer()
		LevelTransition.fadeFromBlack()
		MusicManager.playMusic(preload("res://sunset.ogg"))

func _on_quit_button_pressed():
	if not sceneExited:
		sceneExited = true
		$ButtonPressedSound.play()
		await LevelTransition.fadeToBlack()
		get_tree().quit()

func _on_start_game_button_focus_entered():
	$ButtonSwitchSound.play()

func _on_quit_button_focus_entered():
	$ButtonSwitchSound.play()

func _on_achievements_button_pressed():
	if not sceneExited:
		sceneExited = true
		$ButtonPressedSound.play()
		await LevelTransition.fadeToBlack()
		get_tree().change_scene_to_file("res://achievements.tscn")
		LevelTransition.fadeFromBlack()

func _on_achievements_button_focus_entered():
	$ButtonSwitchSound.play()
