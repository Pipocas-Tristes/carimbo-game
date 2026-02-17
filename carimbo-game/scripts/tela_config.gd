extends Control

signal voltar_pressed

var _resolucao_value: Vector2i
var _modo_value: Window.Mode

@onready var aplicar_btn: Button = $margin/VBoxContainer/TabContainer/Interface/aplicar

func _ready() -> void:
	get_tree().root.min_size = Vector2i(640, 360)
	_resolucao_value = Vector2i(640, 360)
	_modo_value = Window.MODE_EXCLUSIVE_FULLSCREEN

func _process(_delta: float) -> void:
	if (Input.is_action_pressed("ui_cancel")):
		voltar_pressed.emit()

func _on_geral_slider_value_changed(value: float) -> void:
	var geral_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(geral_idx, value)

func _on_efeito_slider_value_changed(value: float) -> void:
	var geral_idx = AudioServer.get_bus_index("Efeitos sonoros")
	AudioServer.set_bus_volume_db(geral_idx, value)

func _on_musica_slider_value_changed(value: float) -> void:
	var geral_idx = AudioServer.get_bus_index("Música")
	AudioServer.set_bus_volume_db(geral_idx, value)

func _on_resolucao_item_selected(index: int) -> void:
	_resolucao_value = Vector2i((index+1) * 640, (index+1) * 360)
	aplicar_btn.disabled = false

func _on_modo_item_selected(index: int) -> void:
	match index:
		0:
			_modo_value = Window.MODE_WINDOWED
		1:
			_modo_value = Window.MODE_EXCLUSIVE_FULLSCREEN
	aplicar_btn.disabled = false

func _on_aplicar_button_up() -> void:
	get_tree().root.content_scale_size = _resolucao_value
	get_tree().root.mode = _modo_value 
	aplicar_btn.disabled = true


func _on_voltar_button_up() -> void:
	voltar_pressed.emit()
