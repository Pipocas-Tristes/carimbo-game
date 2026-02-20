extends Control

signal continuar_opened

const TELA_CONFIG = preload("uid://ds226ph62jpir")
const TELA_LOADING = preload("uid://ck8l2lqfa2r4y")

func _on_continuar_btn_button_up() -> void:
	continuar_opened.emit()

func _on_configurar_btn_button_up() -> void:
	var tela_config: Control = TELA_CONFIG.instantiate()
	add_child(tela_config)
	await tela_config.voltar_pressed
	tela_config.queue_free()

func _on_salvar_e_sair_btn_button_up() -> void:
	var tela_loading = TELA_LOADING.instantiate()
	get_tree().change_scene_to_node(tela_loading)
