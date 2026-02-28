extends ConteudoBase

@onready var sala_supervisor_trigger: SalaSupervisorTrigger = $SalaSupervisorTrigger
@onready var corredor_2_trigger: Corredor2Trigger = $Corredor2Trigger
@onready var quadro: Quadro = $Quadro

func _on_sala_supervisor_trigger_interagido(_player: Variant) -> void:
	trocar_para.emit(sala_supervisor_trigger.destino)

func _on_corredor_2_trigger_interagido(_player: Variant) -> void:
	trocar_para.emit(corredor_2_trigger.destino)

func _on_quadro_interagido(_player: Variant) -> void:
	quadro.monitoring = false
	GameManager.el_papa_foto = true
