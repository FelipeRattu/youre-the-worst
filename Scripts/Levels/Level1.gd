extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.state = "Start"
	GameManager.get_node("Crowd").play()
