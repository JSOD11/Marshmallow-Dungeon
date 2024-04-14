extends Control

var sceneExited = false

func _ready():
	%MenuButton.grab_focus()
	%UnderSixty/DarkLabel.show()
	if CharacterData.difficulties[0] == true:
		%UnderSixty/DarkLabel.hide()
		%UnderSixty/Label.show()
		%UnderSixty/Success.show()
		%UnderThirty/DarkLabel.show()
		if CharacterData.difficulties[1] == true:
			%UnderThirty/DarkLabel.hide()
			%UnderThirty/Label.show()
			%UnderThirty/Success.show()
			%UnderTen/DarkLabel.show()
			if CharacterData.difficulties[2] == true:
				%UnderTen/DarkLabel.hide()
				%UnderTen/Label.show()
				%UnderTen/Success.show()
				%UnderFive/DarkLabel.show()
				if CharacterData.difficulties[3] == true:
					%UnderFive/DarkLabel.hide()
					%UnderFive/Label.show()
					%UnderFive/Success.show()
					%UnderThree/DarkLabel.show()
					if CharacterData.difficulties[4] == true:
						%UnderThree/DarkLabel.hide()
						%UnderThree/Label.show()
						%UnderThree/Success.show()

func _on_menu_button_pressed():
	if not sceneExited:
		sceneExited = true
		SoundManager.playSound(preload("res://table_hit.wav"))
		await LevelTransition.fadeToBlack()
		get_tree().change_scene_to_file("res://start_menu.tscn")
		LevelTransition.fadeFromBlack()

func _on_menu_button_focus_entered():
	SoundManager.playSound(preload("res://teapot.wav"))
