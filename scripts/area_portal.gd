extends Area2D

@export var target_scene_path: String
@export var target_spawn_name: String = "SpawnPoint"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var game_state = get_node("/root/GameState")
		GameState.target_spawn_name = target_spawn_name
		get_tree().change_scene_to_file(target_scene_path)
