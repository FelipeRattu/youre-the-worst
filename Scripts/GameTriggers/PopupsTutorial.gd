extends CanvasLayer

var bar = false
var jump = false
var crouch = false
var pushback = false
var slowdown = false
var distance = false

func _on_BarTutorial_about_to_show():
	bar = true

func _on_JumpTutorial_about_to_show():
	jump = true

func _on_CrouchTutorial_about_to_show():
	crouch = true

func _on_PushbackTutorial_about_to_show():
	pushback = true

func _on_SlowdownTutorial_about_to_show():
	slowdown = true

func _on_DistanceTutorial_about_to_show():
	distance = true

func _input(event):
	
	if event.is_action_pressed("ui_accept") and bar:
		bar = false
		$BarTutorial.hide()
		get_tree().set_deferred("paused", false)
		GameManager.press_key("ui_accept")
	
	if event.is_action_pressed("ui_up") and jump:
		jump = false
		$JumpTutorial.hide()
		get_tree().set_deferred("paused", false)
		yield(get_tree().create_timer(.2), "timeout")
		GameManager.press_key("ui_up")
		
	if event.is_action_pressed("ui_down") and crouch:
		crouch = false
		$CrouchTutorial.hide()
		get_tree().set_deferred("paused", false)
		yield(get_tree().create_timer(.01), "timeout")
		GameManager.press_key("ui_up")
	
	if event.is_action_pressed("ui_left") and pushback:
		pushback = false
		$PushbackTutorial.hide()
		get_tree().set_deferred("paused", false)
		GameManager.press_key("ui_left")
	
	if event.is_action_pressed("ui_left") and slowdown:
		slowdown = false
		$SlowdownTutorial.hide()
		get_tree().set_deferred("paused", false)
		GameManager.press_key("ui_left")
	 
	if event.is_action_pressed("ui_accept") and distance:
		distance = false
		$DistanceTutorial.hide()
		get_tree().set_deferred("paused", false)
		GameManager.press_key("ui_accept")


func _on_YesButton_pressed():
	$WannaTutorial.hide()
	get_tree().set_deferred("paused", false)


func _on_NoButton_pressed():
	$WannaTutorial.hide()
	get_tree().set_deferred("paused", false)
	GameManager.next_level()
