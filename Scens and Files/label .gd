extends Label

var elapsed_time: float = 0.0

func _process(delta):
	if not get_tree().paused:
		elapsed_time += delta
		var total_seconds = int(elapsed_time)
		var minutes = total_seconds / 60
		var seconds = total_seconds % 60
		text = "Час гри: %02d:%02d" % [minutes, seconds]
