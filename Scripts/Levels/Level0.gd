extends Node2D

export var jumpPopup : NodePath
export var crouchPopup : NodePath
export var pushbackPopup : NodePath
export var slowdownPopup : NodePath

export var jumpCollision : NodePath
export var crouchCollision : NodePath
export var pushbackCollision : NodePath
export var slowdownCollision : NodePath

func _ready():
	GameManager.state = "Start"
	GameManager.pushbackCharge = 5

func _on_JumpTrigger_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().set_deferred("paused", true)
		get_node(jumpCollision).set_deferred("disabled", true)
		get_node(jumpPopup).popup_centered()

func _on_CrouchTrigger2_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().set_deferred("paused", true)
		get_node(crouchCollision).set_deferred("disabled", true)
		get_node(crouchPopup).popup_centered()


func _on_PushbackTrigger_body_entered(body):
	if body.is_in_group("Player") and GameManager.state != "Over":
		get_tree().set_deferred("paused", true)
		get_node(pushbackCollision).set_deferred("disabled", true)
		get_node(pushbackPopup).popup_centered()


func _on_SlowdownTrigger_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().set_deferred("paused", true)
		get_node(slowdownCollision).set_deferred("disabled", true)
		get_node(slowdownPopup).popup_centered()
