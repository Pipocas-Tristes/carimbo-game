extends Resource
class_name LetterResource

@export_multiline var content: String
@export_enum("gift", "coal") var correct_stamp: String = 'gift'
@export var is_suspicious: bool = false
@export var texture: Texture2D = null
@export var sender_name: String = ''
