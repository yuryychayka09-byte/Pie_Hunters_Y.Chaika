extends Node

signal hp_changed(current_hp, max_hp)

var max_hp: int = 100
var current_hp: int = 100

# Додай цю змінну для порталів
var last_spawn_id: String = ""

func damage(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)
	emit_signal("hp_changed", current_hp, max_hp)

func heal(amount: int) -> void:
	current_hp = min(current_hp + amount, max_hp)
	emit_signal("hp_changed", current_hp, max_hp)

func reset_hp() -> void:
	current_hp = max_hp
	emit_signal("hp_changed", current_hp, max_hp)
