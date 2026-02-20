extends Control

@onready var progress_bar: ProgressBar = $fundo/margin/VBoxContainer/ProgressBar
@export var next_scene_uid: String = "uid://dfup2bdf5sdnw"

var progress: Array[float] = []

func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene_uid)


func _process(_delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(next_scene_uid, progress)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var porcentagem: float = progress[0] * 100
			progress_bar.value = porcentagem
		ResourceLoader.THREAD_LOAD_LOADED:
			var scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_uid)
			get_tree().change_scene_to_packed(scene)
