extends CanvasLayer

func fadeFromBlack():
	$AnimationPlayer.play("fade_from_black")
	await $AnimationPlayer.animation_finished

func fadeToBlack():
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	
