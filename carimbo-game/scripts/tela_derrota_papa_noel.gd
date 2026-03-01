extends Node2D

@onready var papa_derrotado: Sprite2D = $papa_derrotado
@onready var fundo_escuro: Sprite2D = $fundo_escuro
@onready var carimbo: AnimatedSprite2D = $carimbo
@onready var timer: Timer = $Timer

const TELA_INICIAL = preload(Constants.UID_SCENES[Constants.TELAS.TELA_INICIAL])
const TELA_CREDITOS = preload(Constants.UID_SCENES[Constants.TELAS.TELA_CREDITOS])
const TELA_LOADING: PackedScene = preload(Constants.UID_SCENES[Constants.TELAS.TELA_LOADING])

func _ready() -> void:
	papa_derrotado.modulate.a = 0
	carimbo.position = Vector2(640, -137)
	await _carimbar_papa_noel()
	
	var tela_creditos = TELA_CREDITOS.instantiate()
	add_child(tela_creditos)
	tela_creditos.credito_obrigatorio = true
	await tela_creditos.saiu_dos_creditos
	var tela_loading = TELA_LOADING.instantiate()
	tela_loading.next_scene_uid = Constants.UID_SCENES[Constants.TELAS.TELA_INICIAL]
	get_tree().change_scene_to_node(tela_loading)

func _carimbar_papa_noel() -> void:
	var carimbo_entrando = create_tween().set_ease(Tween.EASE_IN_OUT)
	carimbo_entrando.tween_property(carimbo, "position", Vector2(640, 360), 2.0)
	await carimbo_entrando.finished
	carimbo.play("carimbo_final")
	await carimbo.animation_finished
	carimbo.visible = false
	
	var papa_derrotado_aparecendo = create_tween().set_ease(Tween.EASE_IN_OUT)
	papa_derrotado_aparecendo.tween_property(papa_derrotado, "modulate:a", 1.0, 2.0)
	await papa_derrotado_aparecendo.finished
	papa_derrotado_aparecendo.stop()
	papa_derrotado_aparecendo.tween_property(papa_derrotado, "modulate:a", 0, 2.0)
	papa_derrotado_aparecendo.play()
	await papa_derrotado_aparecendo.finished
	
	
