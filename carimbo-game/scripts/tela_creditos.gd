extends Control

signal saiu_dos_creditos

const SPEED := 100.0
var valor_inicial: float
var tamanho_texto: float

@onready var tela_creditos: Control = $"."
@onready var margin: MarginContainer = $margin

func _ready() -> void:
	tamanho_texto = tela_creditos.size.y
	valor_inicial = margin.position.y
	margin.position.y = absf(tamanho_texto)

func _process(delta: float) -> void:
	var em_cima = valor_inicial - tamanho_texto
	if (margin.position.y > em_cima):
		margin.position.y -= SPEED * delta
	else:
		saiu_dos_creditos.emit()

func _input(event: InputEvent) -> void:
	if (event is InputEventKey || (event is InputEventMouseButton && event.pressed)):
		if (Input.is_action_pressed("ui_cancel")):
			saiu_dos_creditos.emit()
