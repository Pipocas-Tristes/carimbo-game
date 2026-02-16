extends Control

signal novo_jogo_opened
signal configurar_opened

const TELA_CREDITOS: PackedScene = preload("uid://bok2i3ulpkeq8")

func _on_novo_jogo_btn_button_up() -> void:
	novo_jogo_opened.emit()


func _on_configurar_btn_button_up() -> void:
	configurar_opened.emit()


func _on_creditos_btn_button_up() -> void:
	var tela_creditos: Control = TELA_CREDITOS.instantiate()
	add_child(tela_creditos)
	await tela_creditos.saiu_dos_creditos
	tela_creditos.queue_free()
	


func _on_sair_btn_button_up() -> void:
	get_tree().quit()
