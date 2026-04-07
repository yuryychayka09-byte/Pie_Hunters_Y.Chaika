extends Node2D

@onready var pause_menu = $CanvasLayer
@onready var hp_bar = get_node_or_null("/root/Node2D/CanvasLayer3/ProgressBar")

func _ready():
	pause_menu.hide()
	print("HP при старті сцени:", GameState.current_hp)
	if hp_bar:
		hp_bar.update_hp(GameState.current_hp, GameState.max_hp)

func _input(event):
	if event.is_action_pressed("ui_cancel"): # Esc
		if get_tree().paused:
			get_tree().paused = false
			pause_menu.hide()
		else:
			get_tree().paused = true
			pause_menu.show()
