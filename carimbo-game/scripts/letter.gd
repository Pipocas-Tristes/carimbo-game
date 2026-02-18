extends Node2D

var correct_stamp: String = ''
var applied_stamp: String = ''

var dragging: bool = false
var offset: Vector2

@onready var background: ColorRect = $Background
@onready var text_label: Label = $Text
@onready var stamp_mark_label: Label = $StampMarkLabel
@onready var stamp_mark_color: ColorRect = $StampMarkColor

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if is_mouse_over():
					dragging = true;
					offset = global_position - get_global_mouse_position()
			else:
				dragging = false
				check_drop()
				
	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + offset

func check_drop():
	var desk = get_parent()
	
	if desk.send_area.get_overlapping_areas().has($AreaDetector):
		desk.validate_letter(self)

func is_mouse_over() -> bool:
	var rect = background.get_rect()
	var local_mouse = to_local(get_global_mouse_position())
	return rect.has_point(local_mouse)

func setup(letter_text: String, correct: String ):
	text_label.text = letter_text
	correct_stamp = correct
	stamp_mark_color.visible = false

func apply_mark(stamp_type: String):
	if applied_stamp != '':
		return
		
	applied_stamp = stamp_type
	stamp_mark_color.visible = true
	
	if applied_stamp == 'coal':
		stamp_mark_label.text = '🪨'
		stamp_mark_color.modulate = Color.RED
	else:
		stamp_mark_label.text = '🎁'
		stamp_mark_color.modulate = Color.GREEN
