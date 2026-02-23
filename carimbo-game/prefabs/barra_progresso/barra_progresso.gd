extends Control

@onready var barra_valor: TextureProgressBar = $VBoxContainer/barra_valor
@onready var barra_label: Label = $VBoxContainer/barra_label

const FUNDO_GRANDE = preload("uid://dmaw81xrmk2mu")
const FUNDO_MEDIO = preload("uid://bhpynjvstabjk")
const FUNDO_PEQUENO = preload("uid://d006wiqadf7n5")
const PROGRESSAO_GRANDE = preload("uid://bgtrn8gcldmrx")
const PROGRESSAO_MEDIO = preload("uid://eyc4vnrhkgc6")
const PROGRESSAO_PEQUENO = preload("uid://bbvh47n2lbdmy")

enum COR_BARRA {VERMELHA,VERDE,AMARELA}
const _dict_color = {
	COR_BARRA.VERMELHA: Color.CRIMSON,
	COR_BARRA.VERDE: Color.DARK_GREEN,
	COR_BARRA.AMARELA: Color.GOLD,
}
enum {FUNDO,PROGRESSAO}
enum TAMANHO_BARRA {GRANDE,MEDIA,PEQUENA}
const _dict_size = {
	TAMANHO_BARRA.GRANDE: {FUNDO:FUNDO_GRANDE, PROGRESSAO:PROGRESSAO_GRANDE},
	TAMANHO_BARRA.MEDIA: {FUNDO:FUNDO_MEDIO, PROGRESSAO:PROGRESSAO_MEDIO},
	TAMANHO_BARRA.PEQUENA: {FUNDO:FUNDO_PEQUENO, PROGRESSAO:PROGRESSAO_PEQUENO},
}
enum ALINHAMENTO {ESQUERDA,MEIO,DIREITA}
const _dict_alignment = {
	ALINHAMENTO.ESQUERDA: HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT,
	ALINHAMENTO.MEIO: HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER,
	ALINHAMENTO.DIREITA: HorizontalAlignment.HORIZONTAL_ALIGNMENT_RIGHT,
}

@export var alinhamento: ALINHAMENTO = ALINHAMENTO.MEIO
@export var cor: COR_BARRA = COR_BARRA.VERMELHA
@export var tamanho: TAMANHO_BARRA = TAMANHO_BARRA.GRANDE

func _ready() -> void:
	_define_barra_inicial()
	barra_label.horizontal_alignment = _dict_alignment[alinhamento]

func _define_barra_inicial():
	set_valor_inicial()
	barra_valor.set_under_texture(_dict_size[tamanho][FUNDO])
	barra_valor.set_progress_texture(_dict_size[tamanho][PROGRESSAO])
	barra_valor.set_tint_progress(_dict_color[cor])

func aumenta_valor_barra(progresso: float) -> void:
	barra_valor.value = get_valor_barra() + float(progresso)

func diminui_valor_barra(progresso: float) -> void:
	barra_valor.value = get_valor_barra() - float(progresso)

func get_valor_barra() -> float:
	return barra_valor.value

func set_valor_inicial(valor_inicial = 50.0) -> void:
	barra_valor.value = valor_inicial

func set_texto(texto: String) -> void:
	if not texto or not texto.length():
		barra_label.visible = false
	else:
		barra_label.visible = true
		barra_label.text = texto
