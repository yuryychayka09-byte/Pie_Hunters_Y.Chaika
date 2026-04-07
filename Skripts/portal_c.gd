extends Area2D

@export var target_scene: String = "res://Skripts/node_2d.tscn"   # шлях до першої сцени
@export var target_spawn_id = "root_portal"               # ID спавн-поінта у першій сцені
var player_in_range: bool = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("F"):
		GameState.last_spawn_id = target_spawn_id
		get_tree().change_scene_to_file(target_scene)
