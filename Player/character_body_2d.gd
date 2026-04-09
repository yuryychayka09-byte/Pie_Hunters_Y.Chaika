extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var fall_height_threshold: float = 200.0
@export var fall_damage_multiplier: float = 0.4

@onready var sprite: AnimatedSprite2D = $PlayerSprite2D
@onready var dialogue_label = get_node_or_null("/root/Node2D/CanvasLayer3/DialogueLabel")
@onready var hp_bar = get_node_or_null("/root/Node2D/CanvasLayer3/ProgressBar")
@onready var attack_zone: Area2D = $AttackZone

var fall_start_y: float = 0.0
var falling: bool = false
var near_impala: bool = false
var impala_phrase_index: int = 0
var is_dead: bool = false
var is_hurt: bool = false
var is_attacking: bool = false

func _ready() -> void:
	if GameState.current_hp <= 0:
		GameState.current_hp = GameState.max_hp

	if hp_bar:
		hp_bar.update_hp(GameState.current_hp, GameState.max_hp)
		GameState.connect("hp_changed", Callable(hp_bar, "update_hp"))

	# AnimatedSprite2D -> animation_finished без аргументів
	sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

	print("HP при старті Player:", GameState.current_hp)


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# --- рух і стрибки ---
	if not is_on_floor():
		velocity += get_gravity() * delta
		if not falling:
			falling = true
			fall_start_y = global_position.y
		if velocity.y < 0 and not is_hurt and not is_attacking:
			sprite.play("Jump")

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		if not is_hurt and not is_attacking:
			sprite.play("Jump")

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed
		sprite.flip_h = direction < 0
		if is_on_floor() and not is_hurt and not is_attacking:
			sprite.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if is_on_floor() and not is_hurt and not is_attacking:
			sprite.play("Idle")

	move_and_slide()

	if falling and is_on_floor():
		falling = false
		check_fall_damage()

	if near_impala and Input.is_action_just_pressed("F"):
		_on_impala_interacted()

	# --- атака на клавішу I (action "attack") ---
	if Input.is_action_just_pressed("attack"):
		start_attack()


func start_attack():
	if is_attacking or is_hurt or is_dead:
		return
	is_attacking = true
	sprite.play("Attack")
	attack()

	# таймер для скидання стану навіть якщо сигнал не спрацює
	var t = Timer.new()
	t.wait_time = 0.5   # тривалість анімації Attack у секундах
	t.one_shot = true
	add_child(t)
	t.connect("timeout", Callable(self, "_reset_attack"))
	t.start()


func _reset_attack():
	is_attacking = false
	if is_on_floor():
		sprite.play("Idle")
	else:
		sprite.play("Jump")


func _on_animation_finished() -> void:
	# AnimatedSprite2D не передає аргументів, тому перевіряємо sprite.animation
	if sprite.animation == "Hurt_1":
		_reset_hurt()
	elif sprite.animation == "Attack":
		_reset_attack()


func _on_impala_interacted():
	if dialogue_label:
		if impala_phrase_index == 0:
			dialogue_label.text = "Ні, Крихітко, сьогодні я піду пішки."
			impala_phrase_index = 1
		else:
			dialogue_label.text = "Сьогодні Імпала відпочиває, будь людиною — не турбуй мою малу!"
			impala_phrase_index = 0

		var timer = Timer.new()
		timer.wait_time = 7.0
		timer.one_shot = true
		add_child(timer)
		timer.connect("timeout", Callable(self, "_clear_dialogue"))
		timer.start()

func _clear_dialogue():
	if dialogue_label:
		dialogue_label.text = ""

func check_fall_damage() -> void:
	var fall_distance = global_position.y - fall_start_y
	if fall_distance > fall_height_threshold:
		var damage = int((fall_distance - fall_height_threshold) * fall_damage_multiplier)
		take_damage(damage)    

# --- загальний урон (падіння) ---
func take_damage(damage: int) -> void:
	GameState.damage(damage)
	print("HP після урону:", GameState.current_hp)

	if GameState.current_hp <= 0 and not is_dead:
		die()

# --- урон від ворогів з анімацією ---
func take_enemy_damage(damage: int) -> void:
	GameState.damage(damage)
	print("HP після урону від ворога:", GameState.current_hp)

	if sprite:
		is_hurt = true
		sprite.play("Hurt_1")

		var t = Timer.new()
		t.wait_time = 0.5   # тривалість анімації Hurt_1
		t.one_shot = true
		add_child(t)
		t.connect("timeout", Callable(self, "_reset_hurt"))
		t.start()

	if GameState.current_hp <= 0 and not is_dead:
		die()

func _reset_hurt():
	is_hurt = false
	if is_on_floor():
		sprite.play("Idle")
	else:
		sprite.play("Jump")

func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	print("Персонаж помер")
	get_tree().change_scene_to_file("res://Scens and Files/game_over_menu.tscn")

# --- ближня атака ---
func attack():
	var bodies = attack_zone.get_overlapping_bodies()
	print("AttackZone bodies:", bodies)

	for body in bodies:
		if body.is_in_group("Enemy"):
			print("Ворог знайдений:", body)
			if body.has_method("take_damage"):
				print("Наносимо урон ворогу")
				body.take_damage(20)
