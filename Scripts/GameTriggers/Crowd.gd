extends Node2D

var texture1 = preload("res://Sprites/Scenario/Crowd1.png")
var texture2 = preload("res://Sprites/Scenario/Crowd2.png")
var textures = []


func _ready():
	randomize()
	textures.append(texture1)
	textures.append(texture2)
	var number = floor(rand_range(0, 2))
	$Sprite.texture = textures[number]
	$AnimationPlayer.play("Move")
