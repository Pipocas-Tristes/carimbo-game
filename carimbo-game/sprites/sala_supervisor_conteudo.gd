extends ConteudoBase

@onready var corredor_trigger: Area2D = $CorredorTrigger

func _on_corredor_trigger_interagido(_player: Variant) -> void:
	trocar_para.emit(
		corredor_trigger.destino,
		"spawn_corredor_1_dir"
	)
