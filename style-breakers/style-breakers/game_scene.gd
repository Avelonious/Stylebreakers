extends Node2D

var player2Scene = preload("res://player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var player2 = player2Scene.instantiate()
	add_child(player2)
	player2.global_position = Vector2(1130, 476)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func end_of_match():
	var player1_won = $Player.health > 0
	var winnerName = "Player 1"
	if not player1_won:
		winnerName = "Player 2"
		$UI/HUD.end_of_match(winnerName)
