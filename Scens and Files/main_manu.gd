extends Button
func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Skripts/MenuG.tscn")
