extends Area2D

@export var target_scene: String = "res://Scens and Files/root_End.tscn"

var player_in_range: bool = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false

func _process(_delta):
	# Якщо герой у зоні і натиснув F → перехід
	if player_in_range and Input.is_action_just_pressed("F"):
		get_tree().change_scene_to_file(target_scene)
