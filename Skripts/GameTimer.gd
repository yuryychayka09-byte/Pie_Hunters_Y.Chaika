extends Node

var elapsed_time: float = 0.0

func _process(delta: float) -> void:
	elapsed_time += delta

func get_time_string() -> String:
	var minutes = int(elapsed_time) / 60
	var seconds = int(elapsed_time) % 60
	return str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
