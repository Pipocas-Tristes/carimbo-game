extends Control

signal saiu_dos_creditos

@export var SPEED := 50.0
var pos_inicial_credito: float
var pos_final_credito: float
var credito_obrigatorio := false

@onready var panel_container: PanelContainer = $PanelContainer
@onready var margin: MarginContainer = $PanelContainer/margin
const MUSICA_CREDITOS = preload("uid://knjigrxm8wvv")

func _ready() -> void:
	panel_container.position.y = pos_final_credito
	SoundManager.change_musica(MUSICA_CREDITOS)
	
	var tween = create_tween()
	tween.tween_property(panel_container, "position:y", -1352, 60.0).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	await _exibir_fadeout()

func _input(event: InputEvent) -> void:
	if credito_obrigatorio:
		return
	if (event is InputEventKey || (event is InputEventMouseButton && event.pressed)):
		if (Input.is_action_pressed("ui_cancel")):
			SoundManager.stop_musica()
			await _exibir_fadeout()
			saiu_dos_creditos.emit()

func _exibir_fadeout() -> void:
	var tween = create_tween()
	tween.tween_property(margin, "modulate:a", 0, 2.5).set_ease(Tween.EASE_OUT)
	await tween.finished
	SoundManager.stop_musica()
	saiu_dos_creditos.emit()
