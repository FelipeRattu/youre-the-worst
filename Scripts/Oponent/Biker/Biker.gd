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

# Switch Related:
var isOnGround = false
var hasIdled = false
var canCrouch = false

func _ready():
	GameManager.oponentSpeed = maxSpeed

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
	if area.is_in_group("Hitbox"):
		directionY = 1

func _on_ObstacleUp_area_exited(area):
	directionY = 0


func _on_ObstacleFront_area_entered(area):
	if area.is_in_group("Hitbox"):
		directionY = -1


func _on_ObstacleFront_area_exited(area):
	directionY = 0
