extends Area2D
class_name Interagivel

signal interagido(player)

@export var texto_interacao: String = "Interagir"

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.interagivel_atual = self
		body.mostrar_prompt_interacao(true)

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.interagivel_atual = null
		body.mostrar_prompt_interacao(false)

func pode_interagir(_player) -> bool:
	return true

func interagir(player):
	interagido.emit(player)
