extends CharacterBody2D

@export var Jump_action := "ui_accept"
@export var moveRight := "ui_right"
@export var moveLeft := "ui_left"
@export var melee_Action := "p1_melee"


#Jump/Mobility values
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var max_jumps = 2
var jump_count = 0

#Health
@export var max_health: int = 100
var health: int = 0

signal health_changed (health: int, max_health: int)

func _ready() -> void:
	health = max_health
	
	$AnimatedSprite2D.frame_changed.connect(_on_frame_changed)
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)
	
#Take Damge/Health change
func take_damage(amount: int)-> void:
	if health <= 0:
		return
	health = maxi(health - amount, 0) 
	health_changed.emit(health, max_health)

func _physics_process(delta: float) -> void:
	
	 #Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0
	# Handle jump.
	if Input.is_action_just_pressed(Jump_action):
		if is_on_floor() or jump_count < max_jumps:
			velocity.y = JUMP_VELOCITY
			jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis(moveLeft, moveRight)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if (health <= 0):
		$AnimatedSprite2D.play("death")
	elif Input.is_action_just_pressed(Jump_action) or not is_on_floor():
		$AnimatedSprite2D.play("jump")
	elif Input.is_action_pressed(melee_Action):
		$AnimatedSprite2D.play("melee")
	elif direction != 0:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.scale.x = direction
	else:
		$AnimatedSprite2D.play("idle")
		
func _on_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "melee":
		if $AnimatedSprite2D.frame == 3:
			$AnimatedSprite2D/Hitbox.set_deferred("monitoring", true)
		elif $AnimatedSprite2D.frame == 14:
			$AnimatedSprite2D/Hitbox.set_deferred("monitoring", false)
	else:
		$AnimatedSprite2D/Hitbox.set_deferred("monitoring", false)
		
func _on_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		$AnimatedSprite2D/Hitbox/CollisionShape2D.set_deferred("disabled", false)
		$AnimatedSprite2D.play("idle")
	if $AnimatedSprite2D.animation == "death":
		queue_free()
		return
