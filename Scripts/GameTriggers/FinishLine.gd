extends StaticBody2D

var oponentWin : bool =  false
var playerWin : bool = false


func _on_FinishArea_body_entered(body):
	if body.is_in_group("Player") and !oponentWin:
		playerWin = true
		GameManager.causeOfGameOver = "Win"
		GameManager.state = "Over"
	if body.is_in_group("Oponent") and !playerWin:
		oponentWin = true
		if !GameManager.isPlayerDead:
			GameManager.causeOfGameOver = "Lose"
			GameManager.state = "Over"
