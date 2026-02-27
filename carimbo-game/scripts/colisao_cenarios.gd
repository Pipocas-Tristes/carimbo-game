extends Node2D

signal foi_para_esquerda
signal foi_para_direita

@onready var parede_direita: CollisionShape2D = $parede_direita/parede
@onready var parede_esquerda: CollisionShape2D = $parede_esquerda/parede

func reset() -> void:
	parede_esquerda.set_deferred("disabled", false)
	parede_direita.set_deferred("disabled", false)
	print("reset", parede_direita.disabled, parede_esquerda.disabled)

func remove_colisao_esquerda() -> void:
	parede_esquerda.set_deferred("disabled", true)
	print("remove_colisao_esquerda", parede_esquerda.disabled)

func remove_colisao_direita() -> void:
	parede_direita.set_deferred("disabled", true)
	print("remove_colisao_direita", parede_direita.disabled)

func _on_ir_para_direita_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		foi_para_direita.emit()

func _on_ir_para_esquerda_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		foi_para_esquerda.emit()
