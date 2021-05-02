extends CanvasLayer

func _process(delta):
	
	if $Container.rect_position.x == 492:
		$PreviousButton.visible = false
	elif $Container.rect_position.x == -5652:
		$NextButton.visible = false
	else:
		$PreviousButton.visible = true
		$NextButton.visible = true

func _on_NextButton_button_down():
	if $Container.rect_position.x > -5652:
		$Container.rect_position.x -= 1024
		print($Container.rect_position.x)


func _on_PreviousButton_button_down():
	if $Container.rect_position.x < 0:
		$Container.rect_position.x += 1024


func _on_PlayButton_button_down():
	GameManager.next_level()
