extends SalaBase

@onready var supervisor: Area2D = $Interagiveis/Supervisor

const CENARIO_BATALHA = preload("uid://bsce6tf6ehlh4")

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)
	
func _on_dialogue_started():
	pass
	
func _on_dialogue_finished():
	DialogueManager.block_input = false
	
	if GameManager.objetivo_atual == Constants.OBJETIVOS.ENCONTRAR_SUPERVISOR:
		GameManager.set_objetivo(Constants.OBJETIVOS.VOLTAR_TRABALHAR)
		GameManager.pode_levantar = false
		GameManager.next_day()
	
	if GameManager.day == 3:
		var cenario_batalha = CENARIO_BATALHA.instantiate()
		cenario_batalha.inimigo = BatalhasManager.INIMIGOS.SUPERVISOR
		get_tree().change_scene_to_node(cenario_batalha)

func _on_supervisor_interagido(_player: Variant) -> void:
	supervisor.monitoring = false
	
	if GameManager.objetivo_atual == Constants.OBJETIVOS.ENCONTRAR_SUPERVISOR and GameManager.day == 2:
		DialogueManager.start_dialogue([
			{
				"text": "Protagonista: Você?! Por que você descartaria essas cartas?!"
			},
			{
				"text": "Podem ser provas de crimes! No que você está pensando?!"
			},
			{
				"text": "Supervisor: Eu não tenho as suas respostas, só sigo ordens de cima"
			},
			{
				"text": "e você não deveria fazer tantas perguntas, o contrato do emprego explicita isso."
			},
			{
				"text": "Protagonista: eu vou entregar essas cartas para as autoridades com as minhas próprias mãos"
			},
			{
				"text": "Supervisor: se eu fosse você, não faria isso. ELE vai ir atrás de tudo com o que você se importa"
			},
			{
				"text": "Protagonista: Então irei começar derrotando você!!!!"
			},
		], true)
		return
	
	if GameManager.objetivo_atual == Constants.OBJETIVOS.ENCONTRAR_SUPERVISOR and GameManager.day == 1:
		DialogueManager.start_dialogue([
			{
				"text": "Protagonista: Com licença senhor supervisor"
			},
			{
				"text": "em meio às cartas de hoje, encontrei esta."
			},
			{
				"text": "*Entrega a carta para o supervisor*"
			},
			{
				"text": "Supervisor: Não dá muita bola pra isso não"
			},
			{
				"text": "continua seu trabalho."
			}
		], true)
	
	
