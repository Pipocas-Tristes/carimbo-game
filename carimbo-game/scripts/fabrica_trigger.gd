extends Interagivel

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var destino: Constants.CENAS_ORDENADAS

func _ready():
	super._ready()
	sprite_2d.modulate.a = 0

func _on_body_entered(body):
	super._on_body_entered(body)
	
	if body.is_in_group('player'):
		var tween = create_tween()
		tween.tween_property(sprite_2d, "modulate:a", 0.15, 0.3)

func _on_body_exited(body):
	super._on_body_exited(body)
	
	if body.is_in_group('player'):
		var tween = create_tween()
		tween.tween_property(sprite_2d, "modulate:a", 0, 0.3)
