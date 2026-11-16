extends Area2D
@onready var player1_health: ProgressBar = $/root/GameScene/UI/HUD/PlayerHealth
@onready var player2_health: ProgressBar = $/root/GameScene/UI/HUD/EnemyHealth
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", _on_area_entered)
	
func _on_area_entered(hitbox: Area2D)-> void:
	if hitbox.has_method("get_damage"):
		var damage = hitbox.get_damage()
		take_damage(damage)

func take_damage(amount: float):
	if player1_health:
		player1_health.value -= amount
	if player2_health:
		player2_health.value -= amount
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
