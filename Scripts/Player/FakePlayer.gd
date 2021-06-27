extends KinematicBody2D

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

# Speed Related
export var maxSpeed : float
export var acceleration : float

# Force Related
export var jumpForce : float
export var pushbackForce : Vector2
export var slowdownForce : float

# Switch Related:
var isOnGround = false
var hasIdled = false
var canCrouch = false

var pushback = false
var slowdown = false

var tutorialBoxIndex : int = 0

signal pushbackBarFull

func send_x_position():
	return int(position.x)

func apply_motion():
	motion = move_and_slide(motion)

func apply_gravity(delta):
	motion.y += (GRAVITY + weight) * delta

func calculate_velocity(delta):
	velocityX = int(motion.x / delta)
	velocityY = int(motion.y / delta)

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

func _on_GroundDetectionBox_body_entered(body):
	if body.is_in_group("Ground"):
		isOnGround = true
		weight = weightUp

func _on_GroundDetectionBox_body_exited(body):
	if body.is_in_group("Ground"):
		isOnGround = false

func _on_ObstacleUp_area_entered(area):
	if area.is_in_group("Tutorial"):
		print("A: ", tutorialBoxIndex)
		match tutorialBoxIndex:
			1:
				directionY = 1
				canCrouch = true
				tutorialBoxIndex += 1

func _on_ObstacleUp_area_exited(area):
	directionY = 0


func _on_ObstacleFront_area_entered(area):
	if area.is_in_group("Tutorial"):
		print("A: ", tutorialBoxIndex)
		match tutorialBoxIndex:
			0:
				directionY = -1
				tutorialBoxIndex += 1
			2:
				directionY = -1
				tutorialBoxIndex += 1
			3:
				directionY = 0
				pushback = true
				tutorialBoxIndex += 1
			4:
				directionY = 0
				slowdown = true
				tutorialBoxIndex += 1


func _on_ObstacleFront_area_exited(area):
	directionY = 0
	match tutorialBoxIndex:
			3:
				pushback = false
			4:
				slowdown = false

func _on_CrouchTime_timeout():
	canCrouch = false

func _on_SlowdownTimer_timeout():
	var localValue = $SlowdownTimer.time_left

func on_pushback_animation_finished():
	pushback = false

func pushback():
	$Pushback.play()
	motion -= motion + pushbackForce
	pushback = false

func slowdown():
	$Break.play()
	motion.x -= motion.x + slowdownForce

func start_slowdown_timer():
	$SlowdownTimer.start()

func send_pushback_timer_vaue_to_manager():
	var localValue = $SlowdownTimer.time_left
	$ProgressBar.value = localValue

func _on_ProgressBar_value_changed(value):
	if value == 0:
		$PushbackFull.play()


func _on_PushbackFull_finished():
	if tutorialBoxIndex == 0:
		emit_signal("pushbackBarFull")
