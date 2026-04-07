extends Node2D

func _on_start_pressed():
	# Запускаємо головну сцену (Main)
	get_tree().change_scene_to_file("res://Scens and Files/mainS.tscn")

func _on_exit_pressed():
	# Вихід з гри
	get_tree().quit()

func _on_setting_pressed():
	# Тут можна відкрити сцену налаштувань або показати меню
	print("Settings menu opened")
