extends CanvasLayer

signal continuar_selected

const TELA_CONFIG: PackedScene = preload(Constants.UID_SCENES[Constants.TELA_CONFIG])
const TELA_LOADING: PackedScene = preload(Constants.UID_SCENES[Constants.TELA_LOADING])

func _on_continuar_btn_button_up() -> void:
	get_tree().paused = false
	continuar_selected.emit()

func _on_configurar_btn_button_up() -> void:
	var tela_config: Control = TELA_CONFIG.instantiate()
	add_child(tela_config)
	await tela_config.voltar_pressed
	tela_config.queue_free()

func _on_salvar_e_sair_btn_button_up() -> void:
	get_tree().paused = false
	var tela_loading = TELA_LOADING.instantiate()
	get_tree().change_scene_to_node(tela_loading)
