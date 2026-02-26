extends Area2D



func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if body_entered.is_in_group("player"):
		get_tree().change_scene_to_file("res://telas/sala_supervisor.tscn")
