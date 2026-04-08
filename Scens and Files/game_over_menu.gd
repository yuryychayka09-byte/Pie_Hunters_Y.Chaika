extends Control

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Skripts/node_2d.tscn")
   # перезапуск поточної сцени

func _on_exit_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Skripts/MenuG.tscn")
