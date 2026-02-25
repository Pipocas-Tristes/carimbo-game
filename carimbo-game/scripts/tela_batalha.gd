extends CanvasLayer

signal batalha_finalizada(vitoria: bool)

@onready var barra_vida_inimigo: PanelContainer = $barra_vida_inimigo
@onready var barra_vida_player: PanelContainer = $status/MarginContainer/status/barra_vida_player
@onready var barra_energia_player: PanelContainer = $status/MarginContainer/status/barra_energia_player

@onready var vida_btn: Button = $acoes/fundo/MarginContainer/HBoxContainer/VBoxContainer/vida_btn
@onready var energia_btn: Button = $acoes/fundo/MarginContainer/HBoxContainer/VBoxContainer2/energia_btn
@onready var ataque_btn: Button = $acoes/fundo/MarginContainer/HBoxContainer/VBoxContainer/ataque_btn
@onready var especial_btn: Button = $acoes/fundo/MarginContainer/HBoxContainer/VBoxContainer2/especial_btn

@export_category("Inimigo")
@export var nome_inimigo := "La Mama Noel"
@export var vida_inicial_inimigo := 5

@export_category("Player")
@export var vida_inicial_player := 5
@export var energia_inicial_player := 1

@export_category("Ações")
@export var ganho_cura := 1
@export var ganho_energia := 1
@export var custo_ataque := 1
@export var custo_especial := 5

func _ready() -> void:
	_definir_barras_iniciais()
	_definir_texto_botoes()
	_atualizar_estado_botoes()

func _definir_barras_iniciais() -> void:
	barra_vida_inimigo.set_texto(nome_inimigo)
	barra_vida_inimigo.set_valor_inicial(vida_inicial_inimigo)
	barra_vida_player.set_texto("Vida")
	barra_vida_player.set_valor_inicial(vida_inicial_player)
	barra_energia_player.set_texto("Energia")
	barra_energia_player.set_valor_inicial(energia_inicial_player)

func _definir_texto_botoes() -> void:
	var vida_text = vida_btn.text.replace("()", "(+%d de vida)" % ganho_cura)
	var energia_text = energia_btn.text.replace("()", "(+%d energia)" % ganho_energia)
	var ataque_text = ataque_btn.text.replace("()", "(%d dano / -%d energia)" % [custo_ataque, custo_ataque])
	var especial_text = especial_btn.text.replace("()", "(%d dano / -%d energia)" % [custo_especial, custo_especial])
	vida_btn.text = vida_text
	energia_btn.text = energia_text
	ataque_btn.text = ataque_text
	especial_btn.text = especial_text

func _atualizar_estado_botoes() -> void:
	var energia_player_atual = barra_energia_player.get_valor_barra()
	ataque_btn.disabled = true if energia_player_atual < custo_ataque else false
	especial_btn.disabled = true if energia_player_atual < custo_especial else false

func _verifica_estado_batalha() -> void:
	if barra_vida_player.get_valor_barra() <= 0:
		batalha_finalizada.emit(false)
		queue_free()
	elif barra_vida_inimigo.get_valor_barra() <=0:
		batalha_finalizada.emit(true)
		queue_free()

func _on_vida_btn_pressed() -> void:
	barra_vida_player.aumenta_valor_barra(ganho_cura)
	_verifica_estado_batalha()
	_atualizar_estado_botoes()

func _on_energia_btn_pressed() -> void:
	barra_energia_player.aumenta_valor_barra(ganho_energia)
	_verifica_estado_batalha()
	_atualizar_estado_botoes()

func _on_ataque_btn_pressed() -> void:
	barra_vida_inimigo.diminui_valor_barra(custo_ataque)
	barra_energia_player.diminui_valor_barra(custo_ataque)
	_verifica_estado_batalha()
	_atualizar_estado_botoes()

func _on_especial_btn_pressed() -> void:
	barra_vida_inimigo.diminui_valor_barra(custo_especial)
	barra_energia_player.diminui_valor_barra(custo_especial)
	_verifica_estado_batalha()
	_atualizar_estado_botoes()
