extends Control

signal voltar_pressed

var _resolucao_value: Vector2i
var _modo_value: Window.Mode

@onready var modo_select: OptionButton = $margin/VBoxContainer/TabContainer/Interface/modo
@onready var resolucao_select: OptionButton = $margin/VBoxContainer/TabContainer/Interface/resolucao

@onready var aplicar_btn: Button = $margin/VBoxContainer/TabContainer/Interface/aplicar
@onready var controles: VBoxContainer = $margin/VBoxContainer/TabContainer/Controles
const INPUT_BUTTON = preload("uid://bk64nluu06ids")

var is_remapping := false
var acao_para_remap: StringName = ""
var remap_btn: Button = null

const RESOLUCAO_DICT = {
	"640x320" = Vector2i(640, 320),
	"1280x720" = Vector2i(1280, 720),
	"1920x1080" = Vector2i(1920, 1080),
	"2560x1440" = Vector2i(2560, 1440),
}
const MODO_DICT = {
	"Janela" = Window.MODE_WINDOWED,
	"Tela cheia" = Window.MODE_EXCLUSIVE_FULLSCREEN,
}

func _ready() -> void:
	_define_variavel_resolucao()
	_define_controles()

func _process(_delta: float) -> void:
	if (Input.is_action_pressed("ui_cancel")):
		voltar_pressed.emit()

func _input(event: InputEvent) -> void:
	if (event is InputEventKey || (event is InputEventMouseButton && event.pressed)):
		_atualiza_controles(event)

func _define_variavel_resolucao():
	_resolucao_value = get_tree().root.size
	var id := 0
	for key in RESOLUCAO_DICT:
		resolucao_select.add_item(key, id)
		if (RESOLUCAO_DICT[key] == _resolucao_value):
			resolucao_select.select((id))
		id += 1
	
	id = 0
	_modo_value = get_tree().root.mode
	for key in MODO_DICT:
		modo_select.add_item(key, id)
		if (MODO_DICT[key] == _modo_value):
			modo_select.select((id))
		id += 1

func _salvar_nova_resolucao(resolucao: Vector2i, modo: Window.Mode):
	get_tree().root.content_scale_size = resolucao
	get_tree().root.mode = modo
	aplicar_btn.disabled = true

func _define_controles():
	InputMap.load_from_project_settings()
	for item in controles.get_children():
		item.queue_free()
	
	for acao in Constants.ACOES_CUSTOM:
		var acao_text = Constants.ACOES_CUSTOM[acao][Constants.TEXT]
		var acao_event = Constants.ACOES_CUSTOM[acao][Constants.EVENT]
		
		var input_btn = INPUT_BUTTON.instantiate()
		var acao_lbl = input_btn.find_child("acao_lbl")
		var input_lbl = input_btn.find_child("input_lbl")
		
		acao_lbl.text = acao_text
		
		var eventos = InputMap.action_get_events(acao_event)
		input_lbl.text = (eventos.get(0) as InputEvent).as_text().trim_suffix(" - Physical") if eventos.get(0) else ""
		
		controles.add_child(input_btn)
		input_btn.pressed.connect(_on_input_button_pressed.bind(input_btn, acao_event))

func _on_input_button_pressed(input_btn: Button, acao: StringName):
	if not is_remapping:
		is_remapping = true
		acao_para_remap = acao
		remap_btn = input_btn
		input_btn.find_child("input_lbl").text = "Pressione uma tecla..."

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
	_salvar_nova_resolucao(_resolucao_value, _modo_value)

func _on_voltar_button_up() -> void:
	voltar_pressed.emit()
