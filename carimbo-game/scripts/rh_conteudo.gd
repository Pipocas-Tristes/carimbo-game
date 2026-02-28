extends ConteudoBase

@onready var fabrica_trigger: Area2D = $FabricaTrigger
@onready var corredor_trigger_2_rh: Area2D = $CorredorTrigger2Rh

func _on_fabrica_trigger_interagido(_player: Variant) -> void:
	trocar_para.emit(fabrica_trigger.destino)
	
func _on_corredor_trigger_2_rh_interagido(_player: Variant) -> void:
	trocar_para.emit(corredor_trigger_2_rh.destino)
