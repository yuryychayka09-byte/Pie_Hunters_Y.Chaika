extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

@onready var sprite: AnimatedSprite2D = $PlayerSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed
		sprite.flip_h = direction < 0
		sprite.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		sprite.stop()  # стоїмо — зупиняємо анімацію

	move_and_slide()

# Додаємо вихід у меню через Esc
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # стандартно це Esc
		get_tree().change_scene_to_file("res://Skripts/control 01.tscn")
