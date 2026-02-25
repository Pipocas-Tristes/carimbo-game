extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.name == "AreaDetectorEnvelope":
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2, 1), 0.15)

func _on_area_exited(area: Area2D) -> void:
	if area.name == "AreaDetectorEnvelope":
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15)
