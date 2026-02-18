extends Control

signal continuar_opened
signal salvar_e_sair_opened

const TELA_CONFIG = preload("uid://ds226ph62jpir")

func _on_continuar_btn_button_up() -> void:
	continuar_opened.emit()

func _on_configurar_btn_button_up() -> void:
	var tela_config: Control = TELA_CONFIG.instantiate()
	add_child(tela_config)
	await tela_config.voltar_pressed
	tela_config.queue_free()

func _on_salvar_e_sair_btn_button_up() -> void:
	salvar_e_sair_opened.emit()
