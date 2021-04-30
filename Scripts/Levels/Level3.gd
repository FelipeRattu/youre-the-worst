extends Node2D


func _ready():
	GameManager.state = "Start"
	GameManager.get_node("Crowd").play()
