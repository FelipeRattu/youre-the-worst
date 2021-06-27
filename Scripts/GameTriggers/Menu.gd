extends CanvasLayer

onready var animator = $Animations

func _ready():
	animator.play("Text")

func _on_PlayButton_pressed():
	GameManager.next_level()
