extends CharacterBody2D

@export var speed: float = 80.0
@export var gravity: float = 500.0
@export var patrol_distance: float = 150.0
@export var jump_force: float = -300.0
@export var attack_damage: int = 10   # урон за один удар

var start_position: Vector2
var direction: int = 1
var state: String = "patrol"
var player: Node2D = null

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var zone_attack: Area2D = $ZoneAttack
@onready var zone_vision: Area2D = $ZoneVision

func _ready():
	start_position = global_position
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	match state:
		"patrol":
			patrol()
		"chase":
			chase()
		"attack":
			velocity.x = 0

	move_and_slide()

func patrol():
	# якщо ворог дійшов до межі патруля → розвертається і трохи стоїть
	if abs(global_position.x - start_position.x) > patrol_distance:
		direction *= -1
		velocity.x = 0
		anim.play("Idle")
	else:
		velocity.x = direction * speed
		anim.play("Walk")


func chase():
	if player:
		var dir = sign(player.global_position.x - global_position.x)
		velocity.x = dir * speed * 1.2
		anim.play("Run")
		anim.flip_h = dir < 0

		if has_node("ObstacleCheck") and $ObstacleCheck.is_colliding() and is_on_floor():
			velocity.y = jump_force
			anim.play("Jump")

func attack():
	state = "attack"
	var attack_type = randi() % 3 + 1
	anim.play("Attack_" + str(attack_type))

func _on_animation_finished():
	match state:
		"attack":
			if player and zone_attack.overlaps_body(player):
				if player.has_method("take_damage"):
					player.take_damage(attack_damage) # наносимо урон гравцю
				attack() # повторна атака, якщо гравець досі в зоні
			else:
				state = "chase"
		"jump":
			state = "chase"

func _on_zone_vision_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		state = "chase"

func _on_zone_vision_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null
		state = "patrol"
		velocity.x = 0
		anim.play("Idle")

func _on_zone_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		attack()

func _on_zone_attack_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		state = "chase"
func die():
	# створюємо монету при смерті
	var coin_scene = preload("res://Skripts/money.tscn")
	var coin = coin_scene.instantiate()
	coin.global_position = global_position
	get_parent().add_child(coin)

	queue_free()


var hp: int = 50

func take_damage(amount: int):
	hp -= amount
	print("Enemy HP після урону:", hp)
	if hp <= 0:
		die()
