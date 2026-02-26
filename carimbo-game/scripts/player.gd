extends CharacterBody2D
class_name Player 


@export var speed: float = 200.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	var direction := 0
	
	if Input.is_action_pressed("ui_right"):
		direction += 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1

	# Movimento horizontal
	velocity.x = direction * speed
	move_and_slide()

	# Animações
	if direction == 0:
		sprite.play("idle")
	else:
		sprite.play("run")
		sprite.flip_h = direction > 0
