extends ConteudoBase

@onready var corredor_rh_trigger: Area2D = $CorredorRhTrigger

func _on_corredor_rh_trigger_interagido(player: Variant) -> void:
	trocar_para.emit(corredor_rh_trigger.destino)
