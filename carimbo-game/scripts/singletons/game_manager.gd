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

var stash_unlocked: bool = false

signal day_started(day)
signal day_finished(success)
signal game_over

func get_route() -> String:
	if suspicious_stashed_total == 0:
		return "obedient"
	if suspicious_stashed_total < 5:
		return "doubt" 
	else:
		return "rebel"
