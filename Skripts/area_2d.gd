extends Area2D

signal interacted
var player_in_range = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("F"):
		emit_signal("interacted")
