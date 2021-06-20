extends StateMachine

onready var secondaryAnimationPlayer = parent.get_node("SecondaryAnimationPlayer")
var animationEnded : bool = true

func _ready():
	add_state("None")
	add_state("Pushback")
	add_state("Slowdown")
	add_state("Crouch")
	call_deferred("set_state", states.None)

func _state_logic(delta):
	pass

func _get_transition(delta):
	match state:
		states.None:
			if parent.directionX == -1 and !parent.isOnGround and !parent.isDead and parent.canPushBack:
				return states.Pushback
			elif parent.directionX == -1 and parent.isOnGround and !parent.isDead and parent.canSlowdown and parent.hasIdled:
				return states.Slowdown
			elif parent.directionY == 1 and parent.canCrouch and !parent.isDead:
				return states.Crouch
		states.Pushback:
			if parent.directionX == 0 and !parent.isDead and animationEnded:
				return states.None
			elif parent.isDead:
				return states.None
		states.Slowdown:
			if parent.directionX == 0 and !parent.isDead and animationEnded:
				return states.None
			elif parent.isDead:
				return states.None
			elif !parent.isOnGround:
				return states.None
		states.Crouch:
			if parent.directionY == 0 or !parent.canCrouch:
				return states.None
			elif parent.isDead:
				return states.None
			elif parent.directionX == -1 and !parent.isOnGround and !parent.isDead and parent.canPushBack:
				return states.Pushback
			elif parent.directionX == -1 and parent.isOnGround and !parent.isDead and parent.canSlowdown:
				return states.Slowdown

func _enter_state(new_state, old_state):
	match new_state:
		states.None:
			print("None")
			secondaryAnimationPlayer.play("None")
		states.Pushback:
			print("Pushback")
			parent.canPushBack = false
			animationEnded = false
			secondaryAnimationPlayer.play("Blow")
			if parent.motion.x > 0:
				parent.pushback()
		states.Slowdown:
			print("Slowdown")
			animationEnded = false
			secondaryAnimationPlayer.play("Break")
			if parent.motion.x > 0:
				parent.slowdown()
		states.Crouch:
			print("Crouch")
			secondaryAnimationPlayer.play("Crouch")

func _exit_state(old_state, new_state):
	match old_state:
		states.Slowdown:
			parent.start_slowdown_timer()
			secondaryAnimationPlayer.stop()
		states.Pushback:
			parent.start_slowdown_timer()

func _on_animation_ended():
	animationEnded = true
