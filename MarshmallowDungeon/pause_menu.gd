extends CanvasLayer

var sceneExited = false

func showPauseMenu():
	sceneExited = false
	SoundManager.playSound(preload("res://table_hit.wav"))
	get_tree().paused = true
	MusicManager.musicPlayer.volume_db -= 10
	%ContinueButton.grab_focus()
	show()

func _on_continue_button_pressed():
	SoundManager.playSound(preload("res://table_hit.wav"))
	get_tree().paused = false
	MusicManager.musicPlayer.volume_db += 10
	hide()

func _on_quit_button_pressed():
	if not sceneExited:
		MusicManager.musicPlayer.volume_db += 10
		sceneExited = true
		SoundManager.playSound(preload("res://table_hit.wav"))
		Events.currentLevel = 1
		await LevelTransition.fadeToBlack()
		hide()
		get_tree().change_scene_to_file("res://start_menu.tscn")
		MusicManager.musicPlayer.stop()
		get_tree().paused = false
		LevelTransition.fadeFromBlack()

func _on_continue_button_focus_entered():
	SoundManager.playSound(preload("res://teapot.wav"))

func _on_quit_button_focus_entered():
	SoundManager.playSound(preload("res://teapot.wav"))
