extends Node2D
class_name Desk

@onready var emotrometro: Emotrometro = $Emotrometro
@onready var send_area: Area2D = $SendArea
@onready var tashed_area: Area2D = $TashedArea
@onready var send_area_sprite: AnimatedSprite2D = $SendArea/AnimatedSprite2D
@onready var letter_final_spawn: Node2D = $LetterFinalSpawn
@onready var letter_pile_spawn: Node2D = $LetterPileSpawn
const TELA_PAUSE = preload(Constants.UID_SCENES[Constants.TELAS.TELA_PAUSE])

@export_category("Configurações de Progressão")
var required_score: int = 5
var suspicious_tashed: int = 0

@export_category('Configuração de Cena')
@export var letter_scene: PackedScene = null
@export var day_letters: Array[LetterResource] = []
@export var desk_letter_scene: PackedScene = null
var current_letter_resource: LetterResource = null
var current_letter: Node = null

@onready var desk_background: Sprite2D = $DeskBackground
@export var sprite_closed: Texture
@export var sprites: Array[Texture] = []

var current_letter_correct_stamp: String = ''
var selected_stamp: String = ''

var held_stamp: Stamp = null
var held_type: String = ''

var in_focus_mode: bool = false

var intro_phase: int = 0
var intro_active: bool = true

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)
	
	desk_background.texture = sprite_closed
	send_area_sprite.play("idle")
	
	tashed_area.monitoring = GameManager.stash_unlocked
	
	if GameManager.tutorial:
		call_deferred("handle_tutorial_letter")
	
	for i in day_letters.size():
		var desk_letter: DeskLetter = desk_letter_scene.instantiate()
		add_child(desk_letter)
		desk_letter.global_position = Vector2(letter_pile_spawn.position.x + 20 * i, letter_pile_spawn.position.y)
		desk_letter.rotation_degrees = randi_range(-20, 20)
		desk_letter.letter_index = i
		desk_letter.z_index = i + 1
		 

func _input(event: InputEvent) -> void:
	
	if (event is InputEventKey || (event is InputEventMouseButton && event.pressed)):
		_pausar_jogo(event)

func _pausar_jogo(event: InputEvent):
	if (event.is_action_pressed("ui_cancel") and not get_tree().paused):
		get_tree().paused = true
		var tela_pause = TELA_PAUSE.instantiate()
		add_child(tela_pause)
		await tela_pause.continuar_selected
		tela_pause.queue_free()

func generate_latter(letter_index: int) -> void:
	if current_letter != null or day_letters.is_empty():
		return
	
	if GameManager.tutorial and GameManager.tutorial_phase == 1:
		GameManager.clear_tutorial()
	
	current_letter_resource = day_letters[letter_index]
	
	if current_letter_resource.sender_name == "Lívia":
		handle_livia_letter()
	
	if current_letter_resource.sender_name == "Benjamin":
		handle_benjamin_arrival()
	
	current_letter = letter_scene.instantiate()
	add_child(current_letter)
	current_letter.global_position = $LetterSpawn.global_position

	current_letter.letter_stashed.connect(_on_letter_stashed)
	current_letter.setup_from_resource(current_letter_resource, letter_final_spawn.position)

func score_update(value: int):
	GameManager.score += value
	emotrometro.update_emot(GameManager.score)
	
	if value < 0:
		$DeskCamera.shake(2.0)

func validate_letter(letter):
	if letter.applied_stamp == '':
		return
		
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	if GameManager.tutorial:
		GameManager.finish_tutorial()
	
	var correct = letter.applied_stamp == letter.correct_stamp
	letter.queue_free()
	send_area_sprite.play("send_letter")
	await get_tree().create_timer(0.3).timeout

	resolve_letter(current_letter_resource, "send", correct)
	
	send_area_sprite.play("idle")
	current_letter = null
	current_letter_resource = null

func check_day_end():
	if GameManager.letters_processed >= GameManager.max_letters_day:
		end_day()
	
	if GameManager.score < -GameManager.max_errors:
		game_over()

func end_day():
	if GameManager.score >= required_score:
		next_day()
	else:
		game_over()

func next_day():
	GameManager.day += 1
	GameManager.letters_processed = 0
	score_update(0)
	required_score += 2
	GameManager.max_letters_day += 3
	EventManager.check_for_day_event()

func game_over():
	GameManager.day = 0

func _on_letter_stashed(res: LetterResource) -> void:
	resolve_letter(res, "stash")
	current_letter = null

func get_top_letter() -> int:
	var max_z = -999
	
	for child in get_children():
		if child is DeskLetter:
			if child.z_index > max_z:
				max_z = child.z_index
				
	return max_z

func _on_pile_button_pressed() -> void:	
	generate_latter(0)

func resolve_letter(res: LetterResource, decision: String, correct: bool = false):
	match decision:
		"send":
			if correct:
				score_update(1)
				GameManager.humanity += res.moral_weight
			else:
				score_update(-1)
				GameManager.humanity -= res.moral_weight

			GameManager.suspicion += res.suspicion_weight

		"stash":
			if res.is_suspicious:
				GameManager.suspicious_letters.append(res)
				GameManager.suspicious_stashed_total += 1
				GameManager.suspicion -= 1
			else:
				score_update(-2)
				GameManager.suspicion += 2

			suspicious_tashed += 1

	desk_background.texture = sprite_closed
	GameManager.letters_processed += 1
	check_day_end()

func unlock_stash():
	GameManager.stash_unlocked = true
	tashed_area.monitoring = true
	

func _on_tashed_area_area_entered(area: Area2D) -> void:
	if area.name == "AreaDetectorEnvelope" and not in_focus_mode and GameManager.stash_unlocked:
		if suspicious_tashed == 0:
			desk_background.texture = sprites[0]
		elif suspicious_tashed >= 1 and suspicious_tashed < 3:
			desk_background.texture = sprites[1]
		elif suspicious_tashed >= 3 and suspicious_tashed < 5:
			desk_background.texture = sprites[2]
		elif suspicious_tashed >= 5:
			desk_background.texture = sprites[3]

func _on_tashed_area_area_exited(area: Area2D) -> void:
	if area.name == "AreaDetectorEnvelope":
		desk_background.texture = sprite_closed

func _on_dialogue_started():
	if DialogueManager.block_input:
		in_focus_mode = true
	
func _on_dialogue_finished():
	if GameManager.tutorial and GameManager.tutorial_phase == 0:
		GameManager.tutorial_phase += 1
		GameManager.next_tutorial(0)
	
	if DialogueManager.block_input:
		in_focus_mode = false
	
func handle_benjamin_arrival():
	DialogueManager.start_dialogue([
		{
			"text": "Essa carta é… diferente."
		},
		{
			"text": "Talvez eu devesse perguntar alguem sobre"
		}
	], false)

func handle_livia_letter():
	DialogueManager.start_dialogue([
		{
			"text": "A carta apresenta palavras em uma letra bem ilegível"
		},
		{
			"text": "É visível que a criança se empenhou para escrever, mas ainda não sabe como"
		},
		{
			"text": "Abaixo do indecifrável, existe um desenho feito de giz de cera"
		},
		{
			"text": "Ainda que meio torta e com traços difíceis de compreender, parecia uma casa. Talvez uma casa de bonecas?"
		}
	], false)

func handle_tutorial_letter():
	DialogueManager.start_dialogue([
		{
			"text": "Primeiro dia de trabalho"
		},
		{
			"text": "Coisa super fácil, apenas pegar as cartas e carimbar"
		},
		{
			"text": "Se a criança merecer o presente, carimbo verde. Caso não, carimbo vermelho"
		},
	], false)
			
	GameManager.start_tutorial()
