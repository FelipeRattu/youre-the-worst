extends KinematicBody2D

onready var secondaryAnimationPlayer = $SecondaryAnimationPlayer

# Constants
const GRAVITY : float = 400.0

# Character Atributes Related
var weight : float
export var weightUp : float
export var weightDown : float

# Movement Related
var motion : Vector2
var directionX : int
var directionY : int
var velocityX : int
var velocityY : int

# Distance Related
var distance : int
var canCalculateDistance : bool = false
export var maxDistance : int

# Speed Related
export var maxSpeed : float
export var acceleration : float

# Force Related
export var jumpForce : float
export var pushbackForce : Vector2
export var slowdownForce : float

# Switch Related:
var isOnGround : bool = false
var isDead : bool = false
var hasIdled : bool = false
var canCrouch : bool = false
var canPushBack : bool = false
var canSlowdown : bool = false

# Death Related:
var deathDirection : String = "Front"

func apply_motion():
	motion = move_and_slide(motion)

func apply_gravity(delta):
	motion.y += (GRAVITY + weight) * delta

func calculate_velocity(delta):
	velocityX = int(motion.x / delta)
	velocityY = int(motion.y / delta)

func input_handling():
	input_x_axis()
	input_y_axis()

func input_x_axis():
	directionX = -int(Input.is_action_just_pressed("ui_left")) + int(Input.is_action_just_pressed("ui_right"))

func input_y_axis():
	directionY = -int(Input.is_action_just_pressed("ui_up")) + int(Input.is_action_pressed("ui_down"))

func send_x_position():
	return int(position.x)

# Called in the animation player
func finished_idle():
	hasIdled = true
	$Roll.play()
	$StartShot.play()

func run():
	if motion.x < maxSpeed:
		motion.x += acceleration
	else:
		motion.x = maxSpeed

func jump():
	$Jump.play()
	motion.y -= jumpForce

func died():
	GameManager.state = "Over"
	GameManager.isPlayerDead = true

func reduce_speed_while_dead():
	if GameManager.causeOfGameOver == "Death" and motion.x > 0:
		motion.x -= acceleration
	elif GameManager.causeOfGameOver == "Death" and motion.x < 0:
		motion.x += acceleration

func ground_death(type : String):
	if GameManager.causeOfGameOver == "Death":
		match type:
			"Front": secondaryAnimationPlayer.play("FrontFall")
			"Back": secondaryAnimationPlayer.play("BackFall")

func pushback():
	$Pushback.play()
	motion -= motion + pushbackForce

func slowdown():
	$Break.play()
	motion.x -= motion.x + slowdownForce

func check_if_is_too_slow():
	if canCalculateDistance:
		distance = GameManager.calculate_distance()
	
	if distance >= maxDistance:
		GameManager.causeOfGameOver = "Slow"
		GameManager.state = "Over"
	elif GameManager.causeOfGameOver != "Win" and GameManager.causeOfGameOver != "Lose":
		GameManager.causeOfGameOver = "Death"


func toggle_collisions(toggle : bool):
	$Hurtbox/Hurtbox.set_deferred("disabled", !toggle)
	$ObstacleDetectionBack/ObstacleDetectionBack.set_deferred("disabled", !toggle)
	$ObstacleDetectionFront/ObstacleDetectionFront.set_deferred("disabled", !toggle)

func _on_GroundDetectionBox_body_entered(body):
	if body.is_in_group("Ground"):
		isOnGround = true
		canCalculateDistance = true
		weight = weightUp
		if isDead:
			ground_death(deathDirection)

func _on_GroundDetectionBox_body_exited(body):
	if body.is_in_group("Ground"):
		isOnGround = false

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Hitbox"):
		isDead = true
		$HitObstacle.play()
		GameManager.causeOfGameOver = "Death"
		toggle_collisions(false)
		

func _on_ObstacleDetectionFront_area_entered(area):
	if area.is_in_group("Hitbox"):
		deathDirection = "Front"

func _on_ObstacleDetectionBack_area_entered(area):
	if area.is_in_group("Hitbox"):
		deathDirection = "Back"

func start_slowdown_timer():
	canPushBack = false
	canSlowdown = false
	$SlowdownTimer.start()

func _on_SlowdownTimer_timeout():
	canPushBack = true
	canSlowdown = true

func send_pushback_timer_vaue_to_manager():
	var localValue = $SlowdownTimer.time_left
	$ProgressBar.value = localValue

func _on_ProgressBar_value_changed(value):
	if value == 0:
		$PushbackFull.play()
