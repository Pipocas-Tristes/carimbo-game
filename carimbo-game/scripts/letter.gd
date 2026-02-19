extends Node2D
class_name Letter

var current_letter_resource: LetterResource = null

var correct_stamp: String = ''
var applied_stamp: String = ''

var dragging: bool = false
var offset: Vector2

@onready var background: ColorRect = $Background
@onready var text_label: Label = $Text
@onready var stamp_mark_color: ColorRect = $StampMarkColor
@onready var envelope: AnimatedSprite2D = $Envelope
@onready var envelope_shape: CollisionShape2D = $AreaDetectorEnvelope/CollisionShape2D

signal letter_stashed(res: LetterResource)

func _process(_delta: float) -> void:
	if is_mouse_over():
		Input.set_default_cursor_shape(Input.CURSOR_MOVE)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var desk: Desk = get_tree().current_scene
				
				if desk.held_stamp != null and is_mouse_over() and applied_stamp == '':
					apply_mark(desk.held_stamp.type, get_local_mouse_position())
					desk.held_stamp.return_home()
					get_viewport().set_input_as_handled()
					return
				
				if is_mouse_over():
					dragging = true;
					offset = global_position - get_global_mouse_position()
			else:
				dragging = false
				check_drop()

	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + offset

func check_drop():
	var desk: Desk = get_parent()

	if desk.send_area.get_overlapping_areas().has($AreaDetectorEnvelope):
		desk.validate_letter(self)
	elif desk.tashed_area.get_overlapping_areas().has($AreaDetectorEnvelope):
		stash_letter()

func stash_letter():
	letter_stashed.emit(current_letter_resource)
	queue_free()

func show_feedback(correct: bool):
	if correct:
		envelope.modulate = Color(0.6, 1, 0.6)
	else:
		envelope.modulate = Color(1, 0.5, 0.5)

func is_mouse_over() -> bool:
	var local_mouse = to_local(get_global_mouse_position())
	var rect = envelope_shape.shape.get_rect()
	var detector_pos = $AreaDetectorEnvelope.position + envelope_shape.position
	var final_rect = Rect2(rect.position + detector_pos, rect.size)
	
	return final_rect.has_point(local_mouse)

func setup_from_resource(res: LetterResource):
	print(envelope.position)
	
	current_letter_resource = res
	background.visible = false
	text_label.visible = false
	stamp_mark_color.visible = false

	envelope.play("open")
	envelope.animation_finished.connect(_on_open_finished, CONNECT_ONE_SHOT)

func _on_open_finished():
	background.visible = true
	text_label.visible = true
	text_label.text = current_letter_resource.content
	correct_stamp = current_letter_resource.correct_stamp

	envelope.play("idle")
	var tween = create_tween().set_parallel(true)
	tween.tween_property(envelope, "position", Vector2(-150, -50), 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EaseType.EASE_OUT)
	tween.tween_property(envelope, "rotation_degrees", -15.0, 0.4)
	tween.tween_property(envelope, "modulate:a", 0.6, 0.4)

func apply_mark(stamp_type: String, pos: Vector2):
	if applied_stamp != '':
		return

	applied_stamp = stamp_type
	stamp_mark_color.visible = true
	stamp_mark_color.position = pos - (stamp_mark_color.size / 2)

	if applied_stamp == 'coal':
		stamp_mark_color.modulate = Color.RED
	else:
		stamp_mark_color.modulate = Color.GREEN
		
	await get_tree().create_timer(0.5).timeout
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(envelope, "modulate:a", 1.0, 0.4)
	tween.tween_property(envelope, "rotation_degrees", 0.0, 0.4)
	tween.tween_property(envelope, "position", Vector2(-1.35, 59.20), 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EaseType.EASE_IN)
	
	await get_tree().create_timer(0.4).timeout
	
	background.visible = false
	stamp_mark_color.visible = false
	text_label.visible = false
	
	envelope.play("close")
