extends Label

@onready var money_label = self

func _ready():
	# початкове значення
	money_label.text = "Гроші: %d" % GameState.money
	# підключаємо сигнал
	GameState.connect("money_changed", Callable(self, "_update_money_label"))

func _update_money_label(new_value: int):
	money_label.text = "Гроші: %d" % new_value
