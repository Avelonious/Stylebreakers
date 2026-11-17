extends Node

@onready var hit_sound: AudioStreamPlayer = $HitSound
@onready var life_lost_sound: AudioStreamPlayer = $LifeLostSound

var _last_health := {}

func register_player(player: Player) -> void:
	_last_health[player] = player.health
	player.health_changed.connect(_on_health_changed.bind(player))
	player.lives_changed.connect(_on_lives_changed)

func _on_health_changed(current: float, _maximum: float, player: Player) -> void:
	# Only play when health went DOWN (not when it resets after a life is lost)
	if current < _last_health[player]:
		hit_sound.play()
	_last_health[player] = current

func _on_lives_changed(_lives: int) -> void:
	life_lost_sound.play()

func set_music_volume(percent: float) -> void:
	# percent is 0.0 to 1.0
	var bus := AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus, linear_to_db(percent))
