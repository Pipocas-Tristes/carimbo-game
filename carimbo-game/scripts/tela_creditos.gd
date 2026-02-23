extends Control

signal saiu_dos_creditos

@export var SPEED := 50.0
var pos_inicial_credito: float
var pos_final_credito: float
var _terminou_fadeout := false

@onready var tela_creditos: Control = $"."
@onready var margin: MarginContainer = $margin

func _ready() -> void:
	pos_inicial_credito = tela_creditos.position.y
	pos_final_credito = tela_creditos.size.y + pos_inicial_credito
	margin.position.y = pos_final_credito

func _process(delta: float) -> void:
	var bottom_position_credito = margin.size.y + margin.position.y
	if (bottom_position_credito > pos_final_credito):
		margin.position.y -= SPEED * delta
	elif not _terminou_fadeout:
		_terminou_fadeout = true
		_exibir_fadeout()

func _input(event: InputEvent) -> void:
	if (event is InputEventKey || (event is InputEventMouseButton && event.pressed)):
		if (Input.is_action_pressed("ui_cancel")):
			saiu_dos_creditos.emit()

func _exibir_fadeout() -> void:
	var tween = create_tween()
	tween.tween_property(margin, "modulate:a", 0, 2.5).set_ease(Tween.EASE_OUT)
	await tween.finished
	saiu_dos_creditos.emit()
