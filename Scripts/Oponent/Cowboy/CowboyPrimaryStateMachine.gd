extends StateMachine

onready var primaryAnimationPlayer = parent.get_node("PrimaryAnimationPlayer")

func _ready():
	add_state("Idle")
	add_state("Run")
	add_state("Slide")
	add_state("Jump")
	add_state("Fall")
	add_state("Finish")
	call_deferred("set_state", states.Idle)

func _state_logic(delta):
	
	GameManager.oponentPosition = parent.send_x_position()
	
	parent.apply_gravity(delta)
	
	parent.apply_motion()
	
	parent.calculate_velocity(delta)
	
	match state:
		states.Run:
			parent.run()

func _get_transition(delta):
	match state:
		states.Idle:
			if parent.hasIdled:
				return states.Run
		states.Run:
			if parent.directionY == -1:
				return states.Jump
			elif GameManager.state == "Over" and GameManager.causeOfGameOver != "Death":
				return states.Finish
			elif !parent.isOnGround:
				return states.Fall
			elif parent.motion.x >= parent.maxSpeed:
				return states.Slide
		states.Slide:
			if GameManager.state == "Over" and GameManager.causeOfGameOver != "Death":
				return states.Finish
			elif parent.directionY == -1:
				return states.Jump
			elif !parent.isOnGround:
				return states.Fall
			elif parent.motion.x < parent.maxSpeed:
				return states.Run
		states.Jump:
			if parent.velocityY > 0:
				return states.Fall
			elif GameManager.state == "Over" and GameManager.causeOfGameOver != "Death":
				return states.Finish
		states.Fall:
			if parent.isOnGround and parent.motion.x < parent.maxSpeed:
				return states.Run 
			elif parent.isOnGround and parent.motion.x >= parent.maxSpeed:
				return states.Slide
			elif GameManager.state == "Over" and GameManager.causeOfGameOver != "Death":
				return states.Finish

func _enter_state(new_state, old_state):
	match new_state:
		states.Idle:
			primaryAnimationPlayer.play("CowboyIdle")
		states.Run:
			parent.canCrouch = true
			primaryAnimationPlayer.play("CowboyRun")
		states.Slide:
			parent.canCrouch = true
			primaryAnimationPlayer.play("CowboySlide")
		states.Jump:
			parent.weight = parent.weightUp
			parent.jump()
			primaryAnimationPlayer.play("CowboyJump")
		states.Fall:
			parent.weight = parent.weightDown
			primaryAnimationPlayer.play("CowboyFall")
		states.Finish:
			parent.get_node("Roll").stop()
			parent.canCrouch = false
			match GameManager.causeOfGameOver:
				"Win": primaryAnimationPlayer.play("CowboyLose")
				"Lose": primaryAnimationPlayer.play("CowboyWin")
		_: parent.canCrouch = false

func _exit_state(old_state, new_state):
	match old_state:
		states.Fall:
			parent.get_node("Fall").play()
