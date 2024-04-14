extends CharacterBody2D

@export var movementData : PlayerMovementData

@onready var animatedSprite2d = $AnimatedSprite2D
@onready var coyoteTimer = $CoyoteTimer
@onready var startingPosition = global_position
@onready var invincibilityTimer = $InvincibilityTimer
@onready var heartsRect = $"../HUD/Heart"
@onready var camera = $Camera2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var airJump = false
var coinsCollected = 0
var gameStarted = false
var isLooking = [false, false, false, false] # left, right, down, up

func _physics_process(delta):
	setupGame()
	handlePause()
	applyGravity(delta)
	handleJump()
	handleWallJump()
	var inputAxis = Input.get_axis("MoveLeft", "MoveRight")
	handleCamera()
	handleAcceleration(inputAxis, delta)
	applyFriction(inputAxis, delta)
	applyAirResistance(inputAxis, delta)
	updateAnimations(inputAxis)
	var wasOnFloor = is_on_floor()
	move_and_slide()
	if wasOnFloor and not is_on_floor() and velocity.y >= 0.0:
		coyoteTimer.start()
	renderHUD()
	dieAndReset()
	
func setupGame():
	if not gameStarted:
		LevelTransition.fadeFromBlack()
		movementData = load("res://DefaultMovementData.tres")
		CharacterData.hearts = max(CharacterData.hearts, movementData.startingHearts)
		gameStarted = true
		renderHUD()

func handlePause():
	if Input.is_action_just_pressed("Pause"):
		var pauseMenu = get_node("/root/PauseMenu")
		pauseMenu.showPauseMenu()

func applyGravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movementData.gravityScale * delta
		velocity.y = min(velocity.y, 500)
		if is_on_wall():
			velocity.y = min(velocity.y, 80)

func handleWallJump():
	if not is_on_wall_only(): return
	airJump = true
	var wallNormal = get_wall_normal()
	if Input.is_action_just_pressed("Jump") and Input.is_action_pressed("MoveRight") and wallNormal == Vector2.LEFT:
		$JumpSound.play()
		velocity.x = wallNormal.x * movementData.speed * 2
		velocity.y = movementData.jumpVelocity
	if Input.is_action_just_pressed("Jump") and Input.is_action_pressed("MoveLeft") and wallNormal == Vector2.RIGHT:
		$JumpSound.play()
		velocity.x = wallNormal.x * movementData.speed * 2
		velocity.y = movementData.jumpVelocity

func handleJump():
	if is_on_floor() or coyoteTimer.time_left > 0.0:
		airJump = true
		if Input.is_action_just_pressed("Jump"):
			$JumpSound.play()
			velocity.y = movementData.jumpVelocity
	elif not is_on_floor():
		# Shorten jump if we release the jump button.
		if Input.is_action_just_released("Jump") and velocity.y < movementData.jumpVelocity / 2:
			velocity.y = movementData.jumpVelocity / 2
		if airJump == true and Input.is_action_just_pressed("Jump"):
			$JumpSound.play()
			# Allow for a double jump.
			velocity.y = movementData.jumpVelocity
			airJump = false

func look(input, i, isX, shift):
	if not isLooking[i] and Input.is_action_just_pressed(input):
		if isX:
			camera.position.x += shift
		else:
			camera.position.y += shift
		isLooking[i] = true
	elif isLooking[i] and Input.is_action_just_released(input):
		if isX:
			camera.position.x -= shift
		else:
			camera.position.y -= shift
		isLooking[i] = false

func handleCamera():
	look("LookLeft", 0, true, -100)
	look("LookRight", 1, true, 100)
	look("LookUp", 2, false, -100)
	look("LookDown", 3, false, 100)

func handleAcceleration(inputAxis, delta):
	if inputAxis != 0:
		var acceleration = movementData.acceleration
		if not is_on_floor():
			acceleration = movementData.airAcceleration
		velocity.x = move_toward(velocity.x, movementData.speed * inputAxis, acceleration * delta)
			
func applyFriction(inputAxis, delta):
	if inputAxis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movementData.friction * delta)
		
func applyAirResistance(inputAxis, delta):
	if inputAxis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movementData.airResistance * delta)

func updateAnimations(inputAxis):
	if inputAxis != 0:
		animatedSprite2d.flip_h = (inputAxis < 0)
		animatedSprite2d.play("Run")
	else:
		animatedSprite2d.play("Idle")

	if not is_on_floor():
		if velocity.y <= 0:
			animatedSprite2d.play("Jump")
		else:
			animatedSprite2d.play("Fall")

func takeDamage(damage):
	airJump = true
	if invincibilityTimer.time_left > 0.0: return
	SoundManager.playSound(preload("res://take_damage.wav"))
	invincibilityTimer.start()
	CharacterData.hearts -= damage
	await LevelTransition.fadeToBlack()
	LevelTransition.fadeFromBlack()

func renderHUD():
	heartsRect.size.x = CharacterData.hearts * 16

func _on_hazard_detector_area_entered(_area):
	takeDamage(1)
	velocity.y = movementData.jumpVelocity * 1.5
	velocity.x *= 1.5
	
func dieAndReset():
	if CharacterData.hearts == 0:
		SoundManager.playSound(preload("res://death.wav"))
		get_tree().paused = true
		await LevelTransition.fadeToBlack()
		if is_inside_tree():
			get_tree().paused = false
			get_tree().reload_current_scene()

func _on_heart_detector_area_entered(area):
	if area.is_in_group("Hearts"):
		SoundManager.playSound(preload("res://heart.wav"))
		CharacterData.hearts += 1

func _on_coin_detector_area_entered(area):
	if area.is_in_group("Coins"):
		$CoinSound.play()
		coinsCollected += 1
		get_node("../HUD/NumCoins").clear()
		get_node("../HUD/NumCoins").add_text(str(coinsCollected))
