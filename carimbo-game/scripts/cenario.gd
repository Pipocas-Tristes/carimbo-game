extends Node2D

@onready var felco: Player = $felco
@onready var cenario_img: Sprite2D = $cenario_img
@onready var conteudo_container: Node2D = $Conteudo

@export var cena_atual: Constants.CENAS_ORDENADAS
var conteudo_atual: ConteudoBase

const _mapa_conteudos = {
	Constants.CENAS_ORDENADAS.ESCRITORIO: preload("uid://drgsnnyju2haj"),
	Constants.CENAS_ORDENADAS.CORREDOR_1: preload("uid://bsugtk4ao1xgx"),
	Constants.CENAS_ORDENADAS.CORREDOR_2: preload("uid://dx8u2tk73esb1"),
	Constants.CENAS_ORDENADAS.SUPERVISOR: preload("uid://cchabkie6bchw"),
	Constants.CENAS_ORDENADAS.SALA_RH: preload("uid://di2frw21hjxmy"),
	Constants.CENAS_ORDENADAS.FABRICA_DE_BRINQUEDO: preload("uid://buh14ccpn2kjf")
}

enum {ESCALA, IMG_PATH}
const _dict_cenas_ordenadas = {
	Constants.CENAS_ORDENADAS.SALA_RH: {ESCALA: Vector2(2.02, 2.03), IMG_PATH: "uid://2t5e313kw731"},
	Constants.CENAS_ORDENADAS.FABRICA_DE_BRINQUEDO: {ESCALA: Vector2(2.05, 2.05), IMG_PATH: "uid://b5j4alqatx6nx"},
	Constants.CENAS_ORDENADAS.CORREDOR_2: {ESCALA: Vector2(2.03, 2.03), IMG_PATH: "uid://bbfibe7f7axjr"},
	Constants.CENAS_ORDENADAS.CORREDOR_1: {ESCALA: Vector2(2.03, 2.03), IMG_PATH: "uid://cvb1onr4oaisl"},
	Constants.CENAS_ORDENADAS.SUPERVISOR: {ESCALA: Vector2(2.03, 2.03), IMG_PATH: "uid://dax0bjx7l21jb"},
	Constants.CENAS_ORDENADAS.ESCRITORIO: {ESCALA: Vector2(1.005, 1.005), IMG_PATH: "uid://bivdy6tca08ih"},
	Constants.CENAS_ORDENADAS.PONTO_DE_ONIBUS: {ESCALA: Vector2(1.05, 1.05), IMG_PATH: "uid://duujn3wbn8iks"},
	Constants.CENAS_ORDENADAS.CASA: {ESCALA: Vector2(1.47, 1.47), IMG_PATH: "uid://b1s08rt04fq07"},
}

func _ready() -> void:
	_atualiza_cena_atual(cena_atual)

func _atualiza_cena_atual(cena: Constants.CENAS_ORDENADAS, spawn_id: String = '') -> void:
	if GameManager.objetivo_atual == Constants.OBJETIVOS.JULGAR_CARTAS:
		GameManager.set_objetivo(Constants.OBJETIVOS.ENCONTRAR_SUPERVISOR)
	
	if GameManager.objetivo_atual == Constants.OBJETIVOS.JULGAR_OUTRAS_CARTAS:
		GameManager.set_objetivo(Constants.OBJETIVOS.ENCONTRAR_SUPERVISOR)
	
	if conteudo_atual:
		conteudo_atual.on_exit()
		conteudo_atual.queue_free()
	
	cena_atual = cena
	_atualiza_imagem(cena)
	_instancia_conteudo(cena,spawn_id)

func _instancia_conteudo(cena: Constants.CENAS_ORDENADAS, spawn_id: String = '') -> void:
	if !_mapa_conteudos.has(cena):
		return
		
	var cena_scene = _mapa_conteudos[cena]
	conteudo_atual = cena_scene.instantiate()
	
	conteudo_container.add_child(conteudo_atual)
	conteudo_atual.trocar_para.connect(_atualiza_cena_atual)
	conteudo_atual.on_enter()
	_posiciona_player(spawn_id)

func _posiciona_player(spawn_id: String):
	if spawn_id == '':
		return
		
	var spawn_node = conteudo_atual.get_node_or_null("SpawnPoints/" + spawn_id)
	
	if spawn_node:
		felco.global_position = spawn_node.global_position

func _atualiza_imagem(cena: Constants.CENAS_ORDENADAS) -> void:
	cenario_img.texture = load(_dict_cenas_ordenadas[cena][IMG_PATH])
	cenario_img.scale = _dict_cenas_ordenadas[cena][ESCALA]
