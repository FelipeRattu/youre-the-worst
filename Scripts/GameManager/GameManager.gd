extends Node

var menuScene = "res://Scenes/GameTriggers/Menu.tscn"

var levels = [
	"res://Scenes/Levels/Level0.tscn",
	"res://Scenes/Levels/Level1.tscn",
	"res://Scenes/Levels/Level2.tscn",
	"res://Scenes/Levels/Level3.tscn",
	"res://Scenes/GameTriggers/Ending.tscn"
	]
var levelIndex = -1
var nextLevel

var oponentPosition = 0
var playerPosition = 0

var state : String
var causeOfGameOver : String
var isPlayerDead : bool = false

#var pushbackCharge = 1

func calculate_distance():
	var distance = int(oponentPosition - playerPosition)
	
#	if distance < 0:
#		distance *= -1
		
	return distance

func change_icon(icon):
	var list = $UI/HSlider.set("custom_icons/grabber_disabled", icon)

func restart_level():
	stop_all_audios()
	isPlayerDead = false
	get_tree().paused = false
	hide_popups()
	state = "Start"
	get_tree().reload_current_scene()

func hide_popups():
	$Popups/GameOverDead.hide()
	$Popups/GameOverSlow.hide()
	$Popups/Win.hide()
	$Popups/Lose.hide()

func next_level():
	stop_all_audios()
	hide_popups()
	levelIndex +=  1
	nextLevel = levels[levelIndex]
	get_tree().change_scene(nextLevel)

func restart_game():
	levelIndex = -1
	get_tree().change_scene(menuScene)
	

func pause_management():
	if Input.is_action_just_pressed("ui_pause") and state != "Pause" and !isPlayerDead:
		state = "Pause"
	elif Input.is_action_just_pressed("ui_pause") and state == "Pause" and !isPlayerDead:
		state = "Resume"

func pause():
	state = "Pause"
	get_tree().paused = true
	$Popups/PausePopUp.popup_centered()

func resume():
	state = "Resume"
	get_tree().paused = false
	$Popups/PausePopUp.hide()

func game_over():
	state = "Over"
	if causeOfGameOver == "Death":
		$Popups/GameOverDead.popup_centered()
		$Crowd.stop()
		$CrowdBoo.play()
	elif causeOfGameOver == "Slow":
		$Popups/GameOverSlow.popup_centered()
		$Crowd.stop()
		$CrowdBoo.play()
	elif causeOfGameOver == "Win":
		$Popups/Win.popup_centered()
		$Crowd.stop()
		$CrowdCheer.play()
	elif causeOfGameOver == "Lose":
		$Popups/Lose.popup_centered()
		$Crowd.stop()
		$CrowdBoo.play()

func stop_all_audios():
	$CrowdBoo.stop()
	$CrowdCheer.stop()
	$Crowd.stop()

func update_speeds():
	if calculate_distance() >= 0:
		$UI/HSlider.value = calculate_distance()
	
	$UI/PlayerSpeed.text = str(playerPosition)
	$UI/OponentSpeed.text = str(oponentPosition)

func _on_Restart_pressed():
	restart_level()


func _on_NextLevel_pressed():
	next_level()

func press_key(key : String):
	Input.action_press(key)
