extends Area2D

func _on_area_entered(_area):
	queue_free()
	var coins = get_tree().get_nodes_in_group("Coins")
	if coins.size() == 1:
		if get_tree().get_first_node_in_group("EndDoor").doorOnLeft == true:
			Events.endDoorLeft.emit()
		else:
			Events.endDoorRight.emit()
