extends Node2D
@onready var audio = $Audio

var player2Scene = preload("res://player.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	print("players found: ", get_tree().get_nodes_in_group("players").size())
	var player2 = player2Scene.instantiate()
	add_child(player2)
	player2.global_position = Vector2(1130, 476)
# Called every frame. 'delta' is the elapsed time since the previous frame.

# Connect every player to the audio

	for p in find_children("*", "CharacterBody2D", true, false):
		if p.has_signal("health_changed"):
			audio.register_player(p)

func end_of_match():
	var player1_won = $Player.health > 0
	var winnerName = "Player 1"
	if not player1_won:
		winnerName = "Player 2"
		$UI/HUD.end_of_match(winnerName)
