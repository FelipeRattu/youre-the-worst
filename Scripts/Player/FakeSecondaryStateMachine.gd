extends StateMachine

onready var secondaryAnimationPlayer = parent.get_node("SecondaryAnimationPlayer")
var animationEnded : bool = false

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
			if parent.directionY == 1 and parent.canCrouch:
				return states.Crouch
			elif parent.directionY == 0 and parent.pushback:
				return states.Pushback
			elif parent.isOnGround and parent.tutorialBoxIndex == 5:
				return states.Slowdown
		states.Pushback:
			if parent.isOnGround and animationEnded:
				return states.None
		states.Slowdown:
			pass
		states.Crouch:
			if parent.directionY == 0 and !parent.canCrouch:
				return states.None

func _enter_state(new_state, old_state):
	match new_state:
		states.None:
			secondaryAnimationPlayer.play("FakeNone")
		states.Pushback:
			yield(get_tree().create_timer(0.05), "timeout")
			secondaryAnimationPlayer.play("FakeBlow")
			if parent.motion.x > 0:
				parent.pushback()
		states.Slowdown:
			yield(get_tree().create_timer(0.05), "timeout")
			secondaryAnimationPlayer.play("FakeBreak")
			if parent.motion.x > 0:
				parent.slowdown()
		states.Crouch:
			yield(get_tree().create_timer(0.05), "timeout")
			parent.get_node("CrouchTime").start()
			secondaryAnimationPlayer.play("FakeCrouch")

func _exit_state(old_state, new_state):
	match old_state:
		states.Pushback:
			parent.start_slowdown_timer()
		states.Slowdown:
			parent.start_slowdown_timer()
			secondaryAnimationPlayer.stop()

func _on_animation_ended():
	animationEnded = true
