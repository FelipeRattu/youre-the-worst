extends CanvasLayer




func _on_Replay_pressed():
	GameManager.restart_game()
	


func _on_TwitterButton_pressed():
	OS.shell_open("https://twitter.com/FelipeRattu")


func _on_TwitchButton_pressed():
	OS.shell_open("https://www.twitch.tv/feliperattu")
