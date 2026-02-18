extends Node2D

@onready var score_label: Label = $Score
@onready var send_area: Area2D = $SendArea

@export_category('Configuração de Cena')
@export var letter_scene: PackedScene = null
var current_letter: Node = null

var score: int = 0
var current_letter_correct_stamp: String = ''
var selected_stamp: String = ''

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func generate_latter() -> void:
	if current_letter != null:
		return
		
	current_letter = letter_scene.instantiate()
	add_child(current_letter)
	
	current_letter.global_position = $LetterSpawn.global_position
	
	var good = randi() % 2 == 0
	
	if good:
		current_letter.setup(
			"Querido Papai Noel, eu ajudei minha mãe o ano todo.",
            "gift"
		)
	else:
		current_letter.setup(
			"Querido Papai Noel, eu quebrei a TV e culpei meu irmão.",
            "coal"
		)

func validate_letter(letter):
	if letter.applied_stamp == '':
		return
		
	if letter.applied_stamp == letter.correct_stamp:
		score += 1
	else:
		score -= 1
		
	score_label.text = "Score: " + str(score)
	letter.queue_free()
	current_letter = null

func _on_pile_button_pressed() -> void:	
	generate_latter()


func _on_gift_stamp_pressed() -> void:
	if current_letter:
		current_letter.apply_mark('gift')

func _on_coal_stamp_pressed() -> void:
	if current_letter:
		current_letter.apply_mark('coal')
