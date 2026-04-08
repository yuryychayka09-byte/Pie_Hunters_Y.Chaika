extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.near_impala = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		body.near_impala = false
