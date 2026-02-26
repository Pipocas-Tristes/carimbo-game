class_name SceneManager extends Node2D

var scenes_dir_path: String = "res://telas/"	

func change_scene(from, to_scene_name: String) -> void:
	var player = from.get_node("Player")

	if player and player.get_parent():
		player.get_parent().remove_child(player)

	var full_path = scenes_dir_path + to_scene_name + ".tscn"
	from.get_tree().call_deferred("change_scene_to_file", full_path)
