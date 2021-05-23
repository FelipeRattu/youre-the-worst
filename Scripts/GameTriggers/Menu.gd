extends CanvasLayer


export (PackedScene) var instructions

onready var animator = $Animations

func _ready():
	animator.play("Text")

func _on_PlayButton_pressed():
	GameManager.next_level()


func _on_InstructionsButton_pressed():
	get_tree().change_scene_to(instructions)
