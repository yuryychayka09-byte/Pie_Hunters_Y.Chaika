extends Button

func _ready():
	connect("pressed", Callable(self, "_on_exit_pressed"))

func _on_exit_pressed():
	get_tree().quit()
