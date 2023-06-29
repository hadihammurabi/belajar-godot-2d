extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -300.0

var count_jump = 0

@onready var animated_sprite_2d = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var is_jump = handle_jump(delta)

	var direction = Input.get_axis("ui_left", "ui_right")
	handle_flip(direction)
	handle_animation(is_jump, direction)
	handle_move(direction)

	move_and_slide()

func handle_jump(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		count_jump = 0

	var is_jump = Input.is_action_just_pressed("ui_accept")
	if is_jump:
		if count_jump < 2:
			velocity.y = JUMP_VELOCITY
			count_jump += 1

	return is_jump

func handle_move(direction):
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func handle_flip(direction):
	if direction == 1:
		animated_sprite_2d.flip_h = true
	elif direction == -1:
		animated_sprite_2d.flip_h = false

func handle_animation(is_jump, direction):
	if is_jump or not is_on_floor():
		animated_sprite_2d.play("jump")
	elif direction != 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
