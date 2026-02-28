extends CanvasLayer
class_name Tutorial

class TutorialSteps:
	var text: String
	var sound: AudioStream
	
	func _init(t: String, s: AudioStream) -> void:
		text = t
		sound = s

@onready var label: Label = $Label
@export var streams: Array[AudioStream]
var steps: Array[TutorialSteps]

func _ready() -> void:
	steps = [
		TutorialSteps.new("CLIQUE NO ENVELOPE COM [LMB] PARA ABRIR", streams[0]),
		TutorialSteps.new("CLIQUE NA CARTA COM [RMB] PARA ENTRAR/SAIR DO MODO LEITURA", streams[1]),
		TutorialSteps.new("UTILIZE [LMB] PARA ARRASTAR A CARTA/ENVELOPE", streams[2]),
		TutorialSteps.new("CLIQUE EM UM DOS CARIMBOS COM [LMB] PARA SELECIONAR", streams[1]),
		TutorialSteps.new("COM O CARIMBO EM MÃOS CLIQUE NA CARTA COM [LMB] PARA MARCAR", streams[2]),
		TutorialSteps.new("ARRASTE O ENVELOPE ATÉ O CORREIO PARA ENVIAR", streams[1]),
		TutorialSteps.new("PRESSIONE [Q] PARA SAIR DA MESA", streams[1]),
		TutorialSteps.new("USE [A]/[D] PARA MOVIMENTAR O PERSONAGEM", streams[2]),
	]

func next(index: int):
	if index < 0 or index >= steps.size():
		return
		
	var step = steps[index]
	label.text = step.text
	SoundManager.play_sfx(step.sound)
	
func clear():
	label.text = ''
