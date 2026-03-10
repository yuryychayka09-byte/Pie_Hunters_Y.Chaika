extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed
		$PlayerSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
