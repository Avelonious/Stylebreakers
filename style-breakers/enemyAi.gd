extends CharacterBody2D
@onready var target = $"../Player"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta):
	var direction = (target.position-position).normalized()
	velocity = direction * SPEED
	look_at(target.position)
	move_and_slide()
	
