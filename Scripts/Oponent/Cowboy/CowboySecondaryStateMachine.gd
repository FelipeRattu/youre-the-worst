extends StateMachine

onready var secondaryAnimationPlayer = parent.get_node("SecondaryAnimationPlayer")
var animationEnded : bool = true

func _ready():
	add_state("None")
	add_state("Crouch")
	call_deferred("set_state", states.None)

func _state_logic(delta):
	pass

func _get_transition(delta):
	match state:
		states.None:
			if parent.directionY == 1 and parent.canCrouch:
				return states.Crouch
		states.Crouch:
			if parent.directionY == 0 or !parent.canCrouch:
				return states.None

func _enter_state(new_state, old_state):
	match new_state:
		states.None:
			secondaryAnimationPlayer.play("CowboyNone")
		states.Crouch:
			secondaryAnimationPlayer.play("CowboyCrouch")

func _exit_state(old_state, new_state):
	pass

func _on_animation_ended():
	animationEnded = true
