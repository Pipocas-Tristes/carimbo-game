extends Resource
class_name LetterResource

@export_multiline var content: String
@export_enum("gift", "coal") var correct_stamp: String = 'gift'
@export var is_suspicious: bool = false
@export var texture: Texture2D = null
@export var sender_name: String = ''
@export var moral_weight: int = 1
@export var suspicion_weight: int = 0
@export var emotional_weight: int = 0
@export_enum('normal', 'estranha', 'provocativa') var type: String = 'normal'
