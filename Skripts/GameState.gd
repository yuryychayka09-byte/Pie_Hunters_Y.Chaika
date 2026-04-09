extends Node

signal hp_changed(current_hp, max_hp)
signal money_changed(new_value)

var max_hp: int = 100
var current_hp: int = 100
var last_spawn_id: String = ""   # для порталів
var money: int = 0

func damage(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)
	emit_signal("hp_changed", current_hp, max_hp)

func heal(amount: int) -> void:
	current_hp = min(current_hp + amount, max_hp)
	emit_signal("hp_changed", current_hp, max_hp)

func reset_hp() -> void:
	current_hp = max_hp
	emit_signal("hp_changed", current_hp, max_hp)

func add_money(amount: int):
	money += amount
	emit_signal("money_changed", money)

func spend_money(amount: int) -> bool:
	if money >= amount:
		money -= amount
		emit_signal("money_changed", money)
		return true
	return false
