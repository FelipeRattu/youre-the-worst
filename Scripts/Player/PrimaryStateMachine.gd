extends StateMachine

onready var primaryAnimationPlayer = parent.get_node("PrimaryAnimationPlayer")

func _ready():
	add_state("Idle")
	add_state("Run")
	add_state("Slide")
	add_state("Jump")
	add_state("Fall")
	add_state("Finish")
	add_state("Dead")
	call_deferred("set_state", states.Idle)
	
	GameManager.playerSpeed = parent.maxSpeed
	

func _state_logic(delta):
	
	parent.apply_gravity(delta)
	
	parent.apply_motion()
	
	parent.calculate_velocity(delta)
	
	parent.input_handling()
	
	parent.check_if_is_too_slow()
	
	parent.send_pushback_timer_vaue_to_manager()
	
	match state:
		states.Run:
			parent.run()
		states.Dead:
			parent.reduce_speed_while_dead()

func _get_transition(delta):
	match state:
		states.Idle:
			if parent.hasIdled:
				return states.Run
		states.Run:
			if parent.isDead:
				return states.Dead
			elif GameManager.state == "Over" and !parent.isDead:
				return states.Finish
			elif parent.directionY == -1:
				return states.Jump
			elif !parent.isOnGround:
				return states.Fall
			elif parent.motion.x >= parent.maxSpeed:
				return states.Slide
		states.Slide:
			if parent.isDead:
				return states.Dead
			elif GameManager.state == "Over" and !parent.isDead:
				return states.Finish
			elif parent.directionY == -1:
				return states.Jump
			elif !parent.isOnGround:
				return states.Fall
			elif parent.motion.x < parent.maxSpeed:
				return states.Run
		states.Jump:
			if parent.isDead:
				return states.Dead
			elif GameManager.state == "Over" and !parent.isDead:
				return states.Finish
			elif parent.velocityY > 0:
				return states.Fall
		states.Fall:
			if parent.isDead:
				return states.Dead
			elif GameManager.state == "Over" and !parent.isDead:
				return states.Finish
			elif parent.isOnGround and parent.motion.x < parent.maxSpeed:
				return states.Run 
			elif parent.isOnGround and parent.motion.x >= parent.maxSpeed:
				return states.Slide

func _enter_state(new_state, old_state):
	match new_state:
		states.Idle:
			print("Idle")
			primaryAnimationPlayer.play("Idle")
		states.Run:
			print("Run")
			parent.canCrouch = true
			primaryAnimationPlayer.play("Run")
		states.Slide:
			print("Slide")
			parent.canCrouch = true
			primaryAnimationPlayer.play("Slide")
		states.Jump:
			primaryAnimationPlayer.play("Jump")
			parent.weight = parent.weightUp
			parent.jump()
		states.Fall:
			primaryAnimationPlayer.play("Fall")
			parent.weight = parent.weightDown
		states.Dead:
			parent.get_node("Roll").stop()
			if GameManager.causeOfGameOver == "Death":
				match parent.deathDirection:
					"Front": primaryAnimationPlayer.play("FrontDeath")
					"Back": primaryAnimationPlayer.play("BackDeath")
				if parent.isOnGround:
					parent.ground_death(parent.deathDirection)
			parent.died()
		states.Finish:
			parent.get_node("Roll").stop()
			match GameManager.causeOfGameOver:
				"Win": primaryAnimationPlayer.play("Win")
				"Lose": primaryAnimationPlayer.play("Lose")
		_: parent.canCrouch = false
			

func _exit_state(old_state, new_state):
	match old_state:
		states.Fall:
			parent.get_node("Fall").play()
