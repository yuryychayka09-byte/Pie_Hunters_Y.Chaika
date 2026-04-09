extends Area2D

@export var pie_cost: int = 30

var player_in_area: bool = false

func _ready():
	# підключаємо обидва сигнали
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false

func _process(delta):
	# перевіряємо натискання F тільки якщо гравець у зоні
	if player_in_area and Input.is_action_just_pressed("interact"):
		if GameState.money >= pie_cost:
			get_tree().change_scene_to_file("res://Scens and Files/happy_ending.tscn")
		else:
			get_tree().change_scene_to_file("res://Scens and Files/bad_ending.tscn")
