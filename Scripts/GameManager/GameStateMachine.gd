extends StateMachine

func _ready():
	add_state("Start")
	add_state("Over")
	add_state("Pause")
	add_state("Resume")
	call_deferred("set_state", states.Start)

func _state_logic(delta):
	
	parent.calculate_distance()
	
	parent.pause_management()
	
	parent.update_speeds()

func _get_transition(delta):
	match state:
		states.Start:
			if parent.state == "Over":
				return states.Over
			elif parent.state == "Pause":
				return states.Pause
		states.Over:
			if parent.state == "Start":
				return states.Start
		states.Pause:
			if parent.state == "Resume":
				return states.Resume
		states.Resume:
			if parent.state == "Pause":
				return states.Pause
			elif parent.state == "Over":
				return states.Over

func _enter_state(new_state, old_state):
	match new_state:
		states.Start:
			print("GAME STATE: START")
		states.Over:
			parent.game_over()
			print("GAME STATE: OVER")
			print("CAUSE: ", parent.causeOfGameOver)
		states.Pause:
			parent.pause()
			print("GAME STATE: PAUSE")
		states.Resume:
			parent.resume()
			print("GAME STATE: RESUME")

func _exit_state(old_state, new_state):
	pass
