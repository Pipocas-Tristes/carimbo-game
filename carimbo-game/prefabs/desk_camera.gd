extends Camera2D

@onready var focus_overlay: ColorRect = $FocusOverlay
@export var move_intensity: float = 20.0
@export var lerp_speed: float = 2.0
var initial_position: Vector2

func _ready() -> void:
	initial_position = position

func _process(delta: float) -> void:
	var desk: Desk = get_tree().current_scene
	
	if desk.in_focus_mode:
		position = position.lerp(initial_position, delta * lerp_speed)
		focus_overlay.visible = true
		return
	
	focus_overlay.visible = false
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var center_offset = (mouse_pos / viewport_size) - Vector2(0.5, 0.5)
	
	var target_pos = center_offset * move_intensity
	
	position = position.lerp(target_pos, delta * lerp_speed)
