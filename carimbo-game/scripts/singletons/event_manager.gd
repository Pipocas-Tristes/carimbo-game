extends Node


signal event_started(event_id)

var current_event: String = ''

func check_for_day_event():
	var day = GameManager.day
	var route = GameManager.get_route()

	match day:
		3:
			if route == "doubt":
				start_event("first_doubt")
			elif route == "rebel":
				start_event("secret_signal")
		5:
			if route == "rebel":
				start_event("inspection_warning")
		6:
			start_event("final_evaluation")
			
func start_event(event_id: String):
	current_event = event_id
	emit_signal("event_started", event_id)
	print("Evento iniciado:", event_id)
