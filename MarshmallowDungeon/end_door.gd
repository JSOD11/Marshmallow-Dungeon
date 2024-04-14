extends Area2D

@export var doorOnLeft = false

var needToEmit = true

func _on_enddoor_area_entered(_area):
	var coins = get_tree().get_nodes_in_group("Coins")
	if coins.size() == 0 and needToEmit:
		SoundManager.playSound(preload("res://end_level.wav"))
		Events.levelComplete.emit()
		needToEmit = false
