extends Control

signal voltar_pressed

var _resolucao_value: Vector2i
var _modo_value: Window.Mode

@onready var aplicar_btn: Button = $margin/VBoxContainer/TabContainer/Interface/aplicar
@onready var controles: VBoxContainer = $margin/VBoxContainer/TabContainer/Controles
const INPUT_BUTTON = preload("uid://bk64nluu06ids")

var is_remapping := false
var acao_para_remap: StringName = ""
var remap_btn: Button = null

const ACOES_DICT = {
	"para_cima": "Mover para cima",
	"para_baixo": "Mover para baixo",
	"para_esquerda": "Mover para esquerda",
	"para_direita": "Mover para direita",
	"interagir": "Interagir",
}

func _ready() -> void:
	_define_resolucao()
	_define_controles()

func _process(_delta: float) -> void:
	if (Input.is_action_pressed("ui_cancel")):
		voltar_pressed.emit()

func _define_resolucao():
	get_tree().root.min_size = Vector2i(640, 360)
	_resolucao_value = Vector2i(640, 360)
	_modo_value = Window.MODE_EXCLUSIVE_FULLSCREEN

func _define_controles():
	InputMap.load_from_project_settings()
	for item in controles.get_children():
		item.queue_free()
	
	for acao in ACOES_DICT:
		var input_btn = INPUT_BUTTON.instantiate()
		var acao_lbl = input_btn.find_child("acao_lbl")
		var input_lbl = input_btn.find_child("input_lbl")
		
		acao_lbl.text = ACOES_DICT[acao]
		
		var eventos = InputMap.action_get_events(acao)
		print(eventos)
		input_lbl.text = (eventos.get(0) as InputEvent).as_text().trim_suffix(" - Physical") if eventos.get(0) else ""
		
		controles.add_child(input_btn)
		input_btn.toggled.connect(_on_input_button_toggled.bind(input_btn, acao))

func _on_input_button_toggled(_toggled_on: bool, input_btn, acao):
	if not is_remapping:
		is_remapping = true
		acao_para_remap = acao
		remap_btn = input_btn
		input_btn.find_child("input_lbl").text = "Pressione uma tecla..."

func _input(event):
	if (event is InputEventKey || (event is InputEventMouseButton && event.pressed)):
		_atualiza_controles(event)

func _atualiza_controles(event: InputEvent):
	if (is_remapping && remap_btn && acao_para_remap):
		InputMap.action_erase_events(acao_para_remap)
		InputMap.action_add_event(acao_para_remap, event)
		remap_btn.find_child("input_lbl").text = event.as_text().trim_suffix(" - Physical")
		remap_btn.toggle_mode = false
		
		is_remapping = false
		acao_para_remap = ""
		remap_btn = null
	

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
