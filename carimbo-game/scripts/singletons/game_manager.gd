extends Node

var day: int = 1
var letters_processed: int = 0

var score: int = 0
var suspicion: int = 0
var humanity: int = 50
var child_bond: int = 50

var suspicious_letters: Array[LetterResource] = []
var suspicious_stashed_total: int = 0

var required_score: int = 5
var max_letters_day: int = 7
var max_errors: int = 2

var tutorial: bool = true
var tutorial_phase: int = 0
var tutorial_instance
var tutorial_scene = preload(Constants.UID_SCENES[Constants.TELAS.TUTORIAL])

var stash_unlocked: bool = false
var pode_levantar: bool = false

var el_papa_foto: bool = false

# signal day_started(day)
# signal day_finished(success)
# signal game_over

func get_route() -> String:
	if suspicious_stashed_total == 0:
		return "obedient"
	if suspicious_stashed_total < 5:
		return "doubt" 
	else:
		return "rebel"
	
func start_tutorial():
	tutorial = true
	tutorial_instance = tutorial_scene.instantiate()
	get_tree().root.add_child(tutorial_instance)
	
func next_tutorial(res: int):
	tutorial_instance.next(res)
	print(tutorial_phase)
	
func clear_tutorial():
	tutorial_instance.clear()
	
func finish_tutorial():
	if tutorial_instance:
		tutorial_instance.queue_free()
		tutorial_instance = null
		tutorial = false
