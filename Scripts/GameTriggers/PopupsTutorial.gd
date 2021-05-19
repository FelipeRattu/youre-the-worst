extends CanvasLayer

var jump = false
var crouch = false
var pushback = false
var slowdown = false

func _on_JumpTutorial_about_to_show():
	jump = true

func _on_CrouchTutorial_about_to_show():
	crouch = true

func _on_PushbackTutorial_about_to_show():
	pushback = true

func _on_SlowdownTutorial_about_to_show():
	slowdown = true

func _input(event):
	if event.is_action_pressed("ui_up") and jump:
		$JumpTutorial.hide()
		get_tree().set_deferred("paused", false)
		yield(get_tree().create_timer(.2), "timeout")
		GameManager.press_key("ui_up")
		
	
	if event.is_action_pressed("ui_down") and crouch:
		$CrouchTutorial.hide()
		get_tree().set_deferred("paused", false)
		yield(get_tree().create_timer(.01), "timeout")
		GameManager.press_key("ui_up")
	
	if event.is_action_pressed("ui_left") and pushback:
		$PushbackTutorial.hide()
		get_tree().set_deferred("paused", false)
		GameManager.press_key("ui_left")
	
	if event.is_action_pressed("ui_left") and slowdown:
		$SlowdownTutorial.hide()
		get_tree().set_deferred("paused", false)
		GameManager.press_key("ui_left")
