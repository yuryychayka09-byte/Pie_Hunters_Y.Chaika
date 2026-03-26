extends Node2D

@onready var pause_menu = $CanvasLayer

func _ready():
	pause_menu.hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"): # Esc
		if get_tree().paused:
			get_tree().paused = false
			pause_menu.hide()
		else:
			get_tree().paused = true
			pause_menu.show()
