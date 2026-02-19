extends Camera2D

@export var move_intensity: float = 20.0
@export var lerp_speed: float = 2.0

func _process(delta: float) -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var center_offset = (mouse_pos / viewport_size) - Vector2(0.5, 0.5)
	
	var target_pos = center_offset * move_intensity
	
	position = position.lerp(target_pos, delta * lerp_speed)
