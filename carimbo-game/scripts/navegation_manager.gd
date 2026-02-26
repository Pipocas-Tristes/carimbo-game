extends Node
class_name NavigationManager
#cu
const scene_escritorio = preload("res://telas/escritorio.tscn")
const scene_sala_supervisor = preload("res://telas/sala_supervisor.tscn")

var spawn_door_tag

func go_to_level(level_tag,destination_tag):
	var scene_to_load
	
	match level_tag.to_lower().strip_edges():
		"Escritorio":
			scene_to_load = scene_escritorio
		"Sala supervisor":
			scene_to_load = scene_sala_supervisor
	#match level_tag:
		#"Escritorio":
		#	scene_to_load = scene_escritorio
		#"Sala supervisor":
		#	scene_to_load = scene_sala_supervisor
			
	if scene_to_load != null:
		print("Cena encontrada, trocando...")
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)
	else:
		print("Cena NÃO encontrada")
