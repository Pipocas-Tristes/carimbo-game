extends CanvasLayer

var dialogue_queue: Array = []
var in_run: bool = false
var block_input: bool = false

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $ColorRect/Label

func start(dialogues: Array, block := true):
	dialogue_queue = dialogues
	block_input = block
	in_run = true
	
	color_rect.visible = true
	_show_next()

func _show_next():
	if dialogue_queue.is_empty():
		_finish_dialogue()
		return

	label.visible_ratio = 0

	var tween = create_tween()
	var read_time = max(1.5, label.text.length() * 0.03)
	tween.tween_property(label, "visible_ratio", 1, read_time)

	var line = dialogue_queue.pop_front()
	label.text = line.get("text", "")

	if not block_input:
		await get_tree().create_timer(read_time + 1).timeout
		_show_next()

func _input(event):
	if not in_run:
		return

	if event.is_action_pressed("ui_accept"):
		_show_next()

func _finish_dialogue():
	color_rect.visible = false
	in_run = false
	DialogueManager.finish_dialogue()
