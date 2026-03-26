extends CanvasLayer

func _on_resume_to_game_pressed():
	get_tree().paused = false
	hide()



func _on_quit_to_desctop_pressed() -> void:
	get_tree().quit()


func _on_main_manu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Skripts/MenuG.tscn")
