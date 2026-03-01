extends Interagivel


func _on_body_entered(body):
	if GameManager.objetivo_atual != Constants.OBJETIVOS.ENCONTRAR_SUPERVISOR:
		return
		
	super._on_body_entered(body)
