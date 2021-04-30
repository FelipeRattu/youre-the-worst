extends StaticBody2D

export(int, "Up", "Down") var typeOfObstacle

func _ready():
	if typeOfObstacle == 1:
		$AnimationPlayer.play("Idle")
	elif typeOfObstacle == 0:
		$AnimationPlayer.play("IdleUp")

func _on_Hitbox_area_entered(area):
	if area.is_in_group("Hurtbox"):
		if typeOfObstacle == 1:
			$AnimationPlayer.play("Destroy")
		elif typeOfObstacle == 0:
			$AnimationPlayer.play("DestroyUp")
