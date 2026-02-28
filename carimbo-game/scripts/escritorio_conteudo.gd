extends ConteudoBase

@onready var door: Porta = $Door

func _on_door_interagido(_player: Variant) -> void:
	trocar_para.emit(door.destino)

func _on_desk_trigger_interagido(_player: Variant) -> void:
	if  GameManager.pode_levantar:
		DialogueManager.start_dialogue([
			{
				"text": "Não tem pra que voltar agora"
			}
		], false)
		
		return
	get_tree().change_scene_to_file(Constants.UID_SCENES[Constants.TELAS.DESK])
