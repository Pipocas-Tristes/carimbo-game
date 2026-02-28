extends ConteudoBase

@onready var corredor_trigger_1: Area2D = $CorredorTrigger1
@onready var rh_trigger: Area2D = $RHTrigger

func _on_corredor_trigger_1_interagido(_player: Variant) -> void:
	trocar_para.emit(corredor_trigger_1.destino)

func _on_rh_trigger_interagido(_player: Variant) -> void:
	trocar_para.emit(rh_trigger.destino)
