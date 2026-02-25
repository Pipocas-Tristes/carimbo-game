extends Control

@onready var barra_valor: TextureProgressBar = $VBoxContainer/barra_valor
@onready var barra_label: Label = $VBoxContainer/barra_label

const FUNDO_GRANDE = preload("uid://ban1uab6lcvkt")
const PREENCHIMENTO_GRANDE = preload("uid://b4o0tvva5kkwv")
const FUNDO_PEQUENO = preload("uid://cs5xfdpejc681")
const PREENCHIMENTO_PEQUENO = preload("uid://d2xkimrpyqimi")

enum COR_BARRA {VERMELHA,VERDE,AMARELA}
const _dict_color = {
	COR_BARRA.VERMELHA: Color.CRIMSON,
	COR_BARRA.VERDE: Color.DARK_GREEN,
	COR_BARRA.AMARELA: Color.GOLD,
}
enum {FUNDO,PROGRESSAO,FONTE}
enum TAMANHO_BARRA {GRANDE,PEQUENA}
const _dict_size = {
	TAMANHO_BARRA.GRANDE: {FUNDO:FUNDO_GRANDE,PROGRESSAO:PREENCHIMENTO_GRANDE,FONTE:24},
	TAMANHO_BARRA.PEQUENA: {FUNDO:FUNDO_PEQUENO,PROGRESSAO:PREENCHIMENTO_PEQUENO,FONTE:16},
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
	barra_label.add_theme_font_size_override("font_size",_dict_size[tamanho][FONTE])

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
