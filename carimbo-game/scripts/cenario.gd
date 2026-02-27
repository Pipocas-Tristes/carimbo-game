extends Node2D

@onready var felco: Player = $felco
@onready var cenario_img: Sprite2D = $cenario_img
@onready var colisao_cenarios: Node2D = $colisao_cenarios
@onready var spawn_right: Marker2D = $spawn_right
@onready var spawn_left: Marker2D = $spawn_left

@export var cena_atual: Constants.CENAS_ORDENADAS
var cena_esquerda := Constants.CENAS_ORDENADAS.SALA_RH
var cena_direita := Constants.CENAS_ORDENADAS.CASA

enum {ESCALA, IMG_PATH}
const _dict_cenas_ordenadas = {
	Constants.CENAS_ORDENADAS.SALA_RH: {ESCALA: Vector2(2.02, 2.02), IMG_PATH: "uid://2t5e313kw731"},
	Constants.CENAS_ORDENADAS.FABRICA_DE_BRINQUEDO: {ESCALA: Vector2(2.05, 2.05), IMG_PATH: "uid://b5j4alqatx6nx"},
	Constants.CENAS_ORDENADAS.CORREDOR_2: {ESCALA: Vector2(2.02, 2.02), IMG_PATH: "uid://bbfibe7f7axjr"},
	Constants.CENAS_ORDENADAS.CORREDOR_1: {ESCALA: Vector2(2.02, 2.02), IMG_PATH: "uid://cvb1onr4oaisl"},
	Constants.CENAS_ORDENADAS.SUPERVISOR: {ESCALA: Vector2(2.02, 2.02), IMG_PATH: "uid://dax0bjx7l21jb"},
	Constants.CENAS_ORDENADAS.ESCRITORIO: {ESCALA: Vector2(1.47, 1.47), IMG_PATH: "uid://bivdy6tca08ih"},
	Constants.CENAS_ORDENADAS.PONTO_DE_ONIBUS: {ESCALA: Vector2(1.05, 1.05), IMG_PATH: "uid://duujn3wbn8iks"},
	Constants.CENAS_ORDENADAS.CASA: {ESCALA: Vector2(1.47, 1.47), IMG_PATH: "uid://b1s08rt04fq07"},
}

func _ready() -> void:
	_atualiza_cena_atual(cena_atual)

func _atualiza_cena_atual(cena: Constants.CENAS_ORDENADAS) -> void:
	cena_atual = cena
	_atualiza_imagem(cena)
	for cena_idx in _dict_cenas_ordenadas:
		if (cena == cena_idx):
			cena_esquerda = cena_idx - 1 if cena_idx > 0 else 0
			cena_direita = cena_idx + 1 if cena_idx < Constants.CENAS_ORDENADAS.CASA else Constants.CENAS_ORDENADAS.CASA
			break
	_atualiza_colisoes(cena)

func _atualiza_imagem(cena: Constants.CENAS_ORDENADAS) -> void:
	cenario_img.texture = load(_dict_cenas_ordenadas[cena][IMG_PATH])
	cenario_img.scale = _dict_cenas_ordenadas[cena][ESCALA]

func _atualiza_colisoes(cena: Constants.CENAS_ORDENADAS) -> void:
	colisao_cenarios.reset()
	if (cena_esquerda != cena):
		colisao_cenarios.remove_colisao_esquerda()
	if (cena_direita != cena):
		colisao_cenarios.remove_colisao_direita()

func _on_colisao_cenarios_foi_para_direita() -> void:
	_atualiza_cena_atual(cena_direita)
	felco.position = spawn_right.position

func _on_colisao_cenarios_foi_para_esquerda() -> void:
	_atualiza_cena_atual(cena_esquerda)
	felco.position = spawn_left.position
