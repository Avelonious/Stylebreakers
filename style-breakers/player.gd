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
	if Input.is_action_just_pressed(Jump_action) or not is_on_floor():
		$AnimatedSprite2D.play("jump")
	elif Input.is_action_pressed(melee_Action):
		$AnimatedSprite2D.play("melee")
	elif direction != 0:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		$AnimatedSprite2D.play("idle")
