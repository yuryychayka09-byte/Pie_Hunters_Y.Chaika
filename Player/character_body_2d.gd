extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

@export var max_hp: int = 100
var current_hp: int = max_hp

@export var fall_height_threshold: float = 200.0   # висота після якої йде урон
@export var fall_damage_multiplier: float = 0.1    # множник урону

@onready var sprite: AnimatedSprite2D = $PlayerSprite2D

var fall_start_y: float = 0.0
var falling: bool = false

func _ready() -> void:
	get_node("/root/Node2D/CanvasLayer3/ProgressBar").update_hp(current_hp, max_hp)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

		# якщо тільки почали падати — запам’ятати висоту
		if not falling:
			falling = true
			fall_start_y = global_position.y

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed
		sprite.flip_h = direction < 0
		sprite.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		sprite.stop()

	move_and_slide()

	# якщо приземлилися після падіння
	if falling and is_on_floor():
		falling = false
		check_fall_damage()

func check_fall_damage() -> void:
	var fall_distance = global_position.y - fall_start_y
	if fall_distance > fall_height_threshold:
		var damage = int((fall_distance - fall_height_threshold) * fall_damage_multiplier)
		take_damage(damage)

func take_damage(damage: int) -> void:
	current_hp = max(current_hp - damage, 0)
	get_node("/root/Node2D/CanvasLayer3/ProgressBar").update_hp(current_hp, max_hp)
