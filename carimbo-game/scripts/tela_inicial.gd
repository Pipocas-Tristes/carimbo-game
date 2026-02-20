extends Control

const TELA_CREDITOS: PackedScene = preload("uid://bok2i3ulpkeq8")
const TELA_CONFIG: PackedScene = preload("uid://ds226ph62jpir")
const TELA_LOADING: PackedScene = preload("uid://ck8l2lqfa2r4y")

func _ready() -> void:
	_define_resolucao()

func _define_resolucao():
	get_tree().root.min_size = Vector2i(640, 360)
	get_tree().root.content_scale_size = get_tree().root.size
	get_tree().root.mode = Window.MODE_EXCLUSIVE_FULLSCREEN

func _on_novo_jogo_btn_button_up() -> void:
	var tela_loading = TELA_LOADING.instantiate()
	tela_loading.next_scene_path = "res://prefabs/desk.tscn"
	get_tree().change_scene_to_node(tela_loading)

func _on_configurar_btn_button_up() -> void:
	var tela_config: Control = TELA_CONFIG.instantiate()
	add_child(tela_config)
	await tela_config.voltar_pressed
	tela_config.queue_free()

func _on_creditos_btn_button_up() -> void:
	var tela_creditos: Control = TELA_CREDITOS.instantiate()
	add_child(tela_creditos)
	await tela_creditos.saiu_dos_creditos
	tela_creditos.queue_free()

func _on_sair_btn_button_up() -> void:
	get_tree().quit()
