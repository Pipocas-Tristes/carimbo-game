extends CanvasLayer

signal batalha_finalizada(vitoria: bool)

@onready var barra_vida_inimigo: PanelContainer = $barra_vida_inimigo
@onready var barra_vida_player: PanelContainer = $status/MarginContainer/status/barra_vida_player
@onready var barra_energia_player: PanelContainer = $status/MarginContainer/status/barra_energia_player

@onready var turno: TabBar = $Control/acoes/turno
@onready var h_box_container: HBoxContainer = $Control/acoes/fundo/MarginContainer/HBoxContainer
@onready var acao_dialogo: Label = $Control/acoes/fundo/MarginContainer/acao_dialogo
@onready var vida_btn: Button = $Control/acoes/fundo/MarginContainer/HBoxContainer/VBoxContainer/vida_btn
@onready var energia_btn: Button = $Control/acoes/fundo/MarginContainer/HBoxContainer/VBoxContainer2/energia_btn
@onready var ataque_btn: Button = $Control/acoes/fundo/MarginContainer/HBoxContainer/VBoxContainer/ataque_btn
@onready var especial_btn: Button = $Control/acoes/fundo/MarginContainer/HBoxContainer/VBoxContainer2/especial_btn
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var resultado_label: Label = $resultado_container/resultado_label

@export_category("Inimigo")
@export var inimigo: BatalhasManager.INIMIGOS
const valor_ataque_inimigo := 1.0
const vida_inicial_inimigo := 5.0

@export_category("Player")
@export var vida_inicial_player := 5
@export var energia_inicial_player := 1

@export_category("Ações")
@export var nome_cura := "Sanduíche"
@export var ganho_cura := 2.0
@export var nome_energia := "Refri"
@export var ganho_energia := 1.0
@export var nome_ataque := "Denúncia de assédio moral"
@export var custo_ataque := 1.0
@export var nome_especial := "E.C.A."
@export var custo_especial := 5.0

func _ready() -> void:
	_definir_barras_iniciais()
	vida_btn.text = nome_cura
	ataque_btn.text = nome_ataque
	energia_btn.text = nome_energia
	especial_btn.text = nome_especial
	
	_atualizar_estado_botoes()

func _definir_barras_iniciais() -> void:
	barra_vida_inimigo.set_texto(BatalhasManager.INIMIGOS_TEXT[inimigo])
	barra_vida_inimigo.set_valor_inicial(vida_inicial_inimigo)
	barra_vida_player.set_texto("Vida")
	barra_vida_player.set_valor_inicial(vida_inicial_player)
	barra_energia_player.set_texto("Energia")
	barra_energia_player.set_valor_inicial(energia_inicial_player)

func _atualizar_estado_botoes() -> void:
	var energia_player_atual = barra_energia_player.get_valor_barra()
	ataque_btn.disabled = true if energia_player_atual < custo_ataque else false
	especial_btn.disabled = true if energia_player_atual < custo_especial else false

func _verifica_estado_batalha() -> void:
	if barra_vida_player.get_valor_barra() <= 0:
		resultado_label.text = "Derrota"
		animation_player.play("resultado")
		await animation_player.animation_finished
		batalha_finalizada.emit(false)
		queue_free()
	
	if barra_vida_inimigo.get_valor_barra() <=0:
		resultado_label.text = "Vitória"
		animation_player.play("resultado")
		await animation_player.animation_finished
		batalha_finalizada.emit(true)
		queue_free()

func _exibir_dialogo_acao(enemy_turn: bool, item: String, cura: float, energia: float, dano: float) -> void:
	var linha1: String = ""
	var linha2: String = ""
	var linha3: String = ""
	var linha4: String = ""
	
	if (enemy_turn):
		linha1 = "%s usa %s" % [BatalhasManager.INIMIGOS_TEXT[inimigo], item]
	else:
		linha1 = "Você usa %s" % item
	
	if (cura > 0):
		linha2 = "\nVida curada: %d" % ceil(cura)
	
	if (energia > 0):
		linha3 = "\nEnergia recuperada: %d" % ceil(energia)
	if (energia < 0):
		linha3 = "\nEnergia gasta: %d" % -ceil(energia)
	
	if (dano > 0):
		linha4 = "\nDano causado: %d" % ceil(dano)
	
	acao_dialogo.text = linha1 + linha2 + linha3 + linha4
	acao_dialogo.visible = true
	h_box_container.visible = false
	animation_player.play("digitando")
	await animation_player.animation_finished
	await _verifica_estado_batalha()
	
	var tab_turno: String = "Seu turno" if enemy_turn else ("Vez de %s" % BatalhasManager.INIMIGOS_TEXT[inimigo])
	turno.set_tab_title(0, tab_turno)
	_atualizar_estado_botoes()
	if not enemy_turn:
		var random: float = randf()
		var is_atq: bool = random > 0.2
		if is_atq:
			var quantidade_atq: int = len(BatalhasManager.ATQ_INIMIGO)
			var ataque_inimigo_idx := (int(ceil(random*100)) % quantidade_atq)
			print(ataque_inimigo_idx)
			var nome_ataque_inimigo: String = BatalhasManager.ATQ_INIMIGO_TEXT[ataque_inimigo_idx]
			barra_vida_player.diminui_valor_barra(valor_ataque_inimigo)
			await _exibir_dialogo_acao(!enemy_turn, nome_ataque_inimigo, 0.0, 0.0, valor_ataque_inimigo)
		else:
			var quantidade_cura: int = len(BatalhasManager.CURAS_INIMIGO)
			var cura_inimigo_idx := (int(ceil(random*100)) % quantidade_cura)
			print(cura_inimigo_idx)
			var nome_cura_inimigo: String = BatalhasManager.CURAS_INIMIGO_TEXT[cura_inimigo_idx]
			await _exibir_dialogo_acao(!enemy_turn, nome_cura_inimigo, valor_ataque_inimigo, 0.0, 0.0)
	else:
		acao_dialogo.visible = false
		h_box_container.visible = true

func _on_vida_btn_pressed() -> void:
	barra_vida_player.aumenta_valor_barra(ganho_cura)
	await _exibir_dialogo_acao(false, nome_cura, ganho_cura, 0.0, 0.0)

func _on_energia_btn_pressed() -> void:
	barra_energia_player.aumenta_valor_barra(ganho_energia)
	await _exibir_dialogo_acao(false, nome_energia, 0.0, ganho_energia, 0.0)

func _on_ataque_btn_pressed() -> void:
	barra_vida_inimigo.diminui_valor_barra(custo_ataque)
	barra_energia_player.diminui_valor_barra(custo_ataque)
	await _exibir_dialogo_acao(false, nome_ataque, 0.0, -custo_ataque, custo_ataque)

func _on_especial_btn_pressed() -> void:
	barra_vida_inimigo.diminui_valor_barra(custo_especial)
	barra_energia_player.diminui_valor_barra(custo_especial)
	await _exibir_dialogo_acao(false, nome_especial, 0.0, -custo_especial, custo_especial)


func _on_vida_btn_mouse_entered() -> void:
	vida_btn.text = nome_cura + ("\n(+%d de cura)" % ceil(ganho_cura))

func _on_vida_btn_mouse_exited() -> void:
	vida_btn.text = nome_cura

func _on_ataque_btn_mouse_entered() -> void:
	ataque_btn.text = nome_ataque + ("\n(%d de dano / -%d energia)" % [ceil(custo_ataque), ceil(custo_ataque)])

func _on_ataque_btn_mouse_exited() -> void:
	ataque_btn.text = nome_ataque

func _on_energia_btn_mouse_entered() -> void:
	energia_btn.text = nome_energia + ("\n(+%d de energia)" % ganho_energia)

func _on_energia_btn_mouse_exited() -> void:
	energia_btn.text = nome_energia

func _on_especial_btn_mouse_entered() -> void:
	especial_btn.text = nome_especial + ("\n(%d de dano / -%d energia)" % [ceil(custo_especial), ceil(custo_especial)])

func _on_especial_btn_mouse_exited() -> void:
	especial_btn.text = nome_especial
