extends ProgressBar

func _ready():
	update_hp(GameState.current_hp, GameState.max_hp)
	GameState.connect("hp_changed", Callable(self, "_on_hp_changed"))

func update_hp(current_hp: int, max_hp: int):
	max_value = max_hp
	value = current_hp

func _on_hp_changed(current_hp: int, max_hp: int):
	update_hp(current_hp, max_hp)
