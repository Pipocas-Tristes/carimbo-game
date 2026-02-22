extends Node2D
class_name Desk

@onready var emotrometro: Emotrometro = $Emotrometro
@onready var send_area: Area2D = $SendArea
@onready var tashed_area: Area2D = $TashedArea
@onready var send_area_sprite: AnimatedSprite2D = $SendArea/AnimatedSprite2D
@onready var letter_final_spawn: Node2D = $LetterFinalSpawn
@onready var letter_pile_spawn: Node2D = $LetterPileSpawn

@export_category("Configurações de Progressão")
@export var max_letter_day: int = 7
var required_score: int = 5
var day: int = 1
var letters_processed: int = 0
var max_errors: int = 2
var suspicious_pile: Array[LetterResource]
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

var score: int = 0
var current_letter_correct_stamp: String = ''
var selected_stamp: String = ''

var held_stamp: Stamp = null
var held_type: String = ''

var in_focus_mode: bool = false

func _ready() -> void:
	desk_background.texture = sprite_closed
	send_area_sprite.play("idle")
	
	for i in day_letters.size():
		var desk_letter: DeskLetter = desk_letter_scene.instantiate()
		add_child(desk_letter)
		desk_letter.global_position = Vector2(letter_pile_spawn.position.x + 20 * i, letter_pile_spawn.position.y)
		desk_letter.rotation_degrees = randi_range(-20, 20)
		desk_letter.letter_index = i
		desk_letter.z_index = i + 1
		 

func _process(_delta: float) -> void:
	pass

func generate_latter(letter_index: int) -> void:
	if current_letter != null or day_letters.is_empty():
		return
		
	current_letter_resource = day_letters[letter_index]
		
	current_letter = letter_scene.instantiate()
	add_child(current_letter)
	current_letter.global_position = $LetterSpawn.global_position

	current_letter.letter_stashed.connect(_on_letter_stashed)
	current_letter.setup_from_resource(current_letter_resource, letter_final_spawn.position)

func score_update(value: int):
	score += value
	emotrometro.update_emot(score)
	
	if value < 0:
		$DeskCamera.shake(2.0)

func validate_letter(letter):
	if letter.applied_stamp == '':
		return
	
	var correct = letter.applied_stamp == letter.correct_stamp
	letter.queue_free()
	send_area_sprite.play("send_letter")
	await get_tree().create_timer(0.3).timeout
	
	if correct:
		score_update(1)
	else:
		score_update(-1)
	
	send_area_sprite.play("idle")
	
	current_letter = null
	
	letters_processed += 1
	check_day_end()

func check_day_end():
	if letters_processed >= max_letter_day:
		end_day()
	
	if score < -max_errors:
		game_over()

func end_day():
	if score >= required_score:
		next_day()
	else:
		game_over()

func next_day():
	day += 1
	letters_processed = 0
	score_update(0)
	required_score += 2
	max_letter_day += 3

func game_over():
	day = 0

func _on_letter_stashed(res: LetterResource) -> void:
	if res.is_suspicious:
		suspicious_pile.append(res)
	else:
		score_update(-2)
		
	suspicious_tashed += 1

func get_top_letter() -> int:
	var max_z = -999
	
	for child in get_children():
		if child is DeskLetter:
			if child.z_index > max_z:
				max_z = child.z_index
				
	return max_z

func _on_pile_button_pressed() -> void:	
	generate_latter(0)


func _on_tashed_area_area_entered(area: Area2D) -> void:
	if area.name == "AreaDetectorEnvelope" and not in_focus_mode:
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
