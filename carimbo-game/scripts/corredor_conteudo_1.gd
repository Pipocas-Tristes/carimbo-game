extends ConteudoBase

@onready var sala_supervisor_trigger: SalaSupervisorTrigger = $SalaSupervisorTrigger
@onready var corredor_2_trigger: Corredor2Trigger = $Corredor2Trigger
@onready var quadro: Quadro = $Quadro
@onready var escritorio_trigger: Area2D = $EscritorioTrigger

func _on_sala_supervisor_trigger_interagido(_player: Variant) -> void:
	trocar_para.emit(
		sala_supervisor_trigger.destino, 
		"spawn_supervisor"
	)

func _on_corredor_2_trigger_interagido(_player: Variant) -> void:
	trocar_para.emit(
		corredor_2_trigger.destino,
		"spawn_corredor_2_dir"
	)

func _on_quadro_interagido(_player: Variant) -> void:
	quadro.monitoring = false
	GameManager.el_papa_foto = true


func _on_escritorio_trigger_interagido(_player: Variant) -> void:
	trocar_para.emit(
		escritorio_trigger.destino,
		"spawn_escritorio_porta"
	)
