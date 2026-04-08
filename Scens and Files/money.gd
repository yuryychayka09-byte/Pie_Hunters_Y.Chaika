extends Area2D

@export var value: int = 1

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		GameState.add_money(value) # додаємо гроші у глобальний GameState
		queue_free() # монета зникає після підбору
