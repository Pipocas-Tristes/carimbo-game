extends Node2D
class_name Emotrometro

@onready var seta: Sprite2D = $Seta

@export var score_min: int = -10
@export var score_max: int = 10

var angle_min: float = -85.0
var angle_max: float = 85.0

func update_emot(current_score: float):
	var new_angle = remap(current_score, score_min, score_max, angle_min, angle_max)
	print('New Angle: ' + str(new_angle) + ' | Score: ' + str(current_score))
	
	new_angle = clamp(new_angle, angle_min, angle_max)
	print('New Angle: ' + str(new_angle) + ' | Score: ' + str(current_score))
	
	var tween = create_tween()
	tween.tween_property(seta, "rotation_degrees", new_angle, 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
