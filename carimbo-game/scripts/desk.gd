extends Node2D
class_name Desk

@onready var send_area: Area2D = $SendArea
@onready var tashed_area: Area2D = $TashedArea
@onready var emotrometro: Emotrometro = $Emotrometro

@export_category("Configurações de Progressão")
@export var max_letter_day: int = 7
var required_score: int = 5
var day: int = 1
var letters_processed: int = 0
var max_errors: int = 2
var suspicious_pile: Array[LetterResource]

@export_category('Configuração de Cena')
@export var letter_scene: PackedScene = null
@export var day_letters: Array[LetterResource] = []
var current_letter_resource: LetterResource = null
var current_letter: Node = null

var score: int = 0
var current_letter_correct_stamp: String = ''
var selected_stamp: String = ''

var held_stamp: Stamp = null
var held_type: String = ''

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func generate_latter() -> void:
	if current_letter != null or day_letters.is_empty():
		return
		
	current_letter_resource = day_letters.pop_front()
		
	current_letter = letter_scene.instantiate()
	add_child(current_letter)
	current_letter.global_position = $LetterSpawn.global_position
	current_letter.letter_stashed.connect(_on_letter_stashed)
	current_letter.setup_from_resource(current_letter_resource)

func score_upadte(value: int):
	score += value
	emotrometro.update_emot(score)
	print(score)

func validate_letter(letter):
	if letter.applied_stamp == '':
		return
	
	var correct = letter.applied_stamp == letter.correct_stamp
	
	if correct:
		score_upadte(1)
	else:
		score_upadte(-1)
	
	letter.show_feedback(correct)
	
	await get_tree().create_timer(0.5).timeout
	
	letter.queue_free()
	current_letter = null
	
	letters_processed += 1
	check_day_end()
	
	print(str(letters_processed) + ' | ' + str(max_letter_day))

func check_day_end():
	if letters_processed >= max_letter_day:
		end_day()
	
	if score < -max_errors:
		game_over()
		
func end_day():
	if score >= required_score:
		print('Dia completo com sucesso')
		next_day()
	else:
		print('Falhou no dia...')
		game_over()

func next_day():
	day += 1
	letters_processed = 0
	score_upadte(0)
	required_score += 2
	max_letter_day += 3
	
	print('Começando dia ', str(day))
	
func game_over():
	print("Game Over")
	day = 0

func _on_letter_stashed(res: LetterResource) -> void:
	if res.is_suspicious:
		suspicious_pile.append(res)
		print("Você guardou uma prova! Total: ", suspicious_pile.size())
	else:
		score_upadte(-2)

func _on_pile_button_pressed() -> void:	
	generate_latter()
