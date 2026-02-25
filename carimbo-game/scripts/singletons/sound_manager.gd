extends Node

const NUMERO_AUDIOS_SIMULTANEOS = 5
const MIN_DB = -35.5
const MAX_DB = 0.0
const MIN_PERCENT = 0.0
const MAX_PERCENT = 100.0

var sfx_players: Array[AudioStreamPlayer] = []
var _musica_player: AudioStreamPlayer 

func _ready() -> void:
	_musica_player = AudioStreamPlayer.new()
	_musica_player.bus = "Música"
	add_child(_musica_player)
	
	for i in NUMERO_AUDIOS_SIMULTANEOS:
		var player = AudioStreamPlayer.new()
		player.bus = "Efeitos sonoros"
		add_child(player)
		sfx_players.append(player)

func play_sfx(stream: AudioStream):
	for player in sfx_players:
		if not player.playing:
			player.stream = stream
			player.play()
			return

func change_musica(stream: AudioStream, esperaAcabar = false):
	if (esperaAcabar):
		await _musica_player.finished
	_musica_player.stream = stream
	_musica_player.play()

func stop_musica():
	_musica_player.stop()

func set_volume(percent: float, bus_name: StringName = "Master"):
	#limita conforme o valor minimo e maximo
	percent = MAX_PERCENT if (percent > MAX_PERCENT) else percent
	percent = MIN_PERCENT if (percent < MIN_PERCENT) else percent
	var idx = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(idx, _map_to_bus_volume(percent))

func get_volume(bus_name: StringName = "Master"):
	var bus_vol = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name))
	return _map_to_percent_volume(bus_vol)

func _map_to_percent_volume(bus: float) -> float:
	# (percent-MIN_PERCENT)/(MAX_PERCENT-MIN_PERCENT) = (bus-MIN_DB)/(MAX_DB-MIN_DB)
	# percent-MIN_PERCENT = (MAX_PERCENT-MIN_PERCENT)*(bus-MIN_DB)/(MAX_DB-MIN_DB)
	# percent = ((MAX_PERCENT-MIN_PERCENT)*(bus-MIN_DB)/(MAX_DB-MIN_DB)) + MIN_PERCENT
	var percent = ((MAX_PERCENT-MIN_PERCENT)*(bus-MIN_DB)/(MAX_DB-MIN_DB)) + MIN_PERCENT
	return percent

func _map_to_bus_volume(percent: float) -> float:
	#(bus-MIN_DB)/(MAX_DB-MIN_DB) = (percent-MIN_PERCENT)/(MAX_PERCENT-MIN_PERCENT)
	#bus-MIN_DB = (MAX_DB-MIN_DB)*(percent-MIN_PERCENT)/(MAX_PERCENT-MIN_PERCENT)
	#bus = (MAX_DB-MIN_DB)*(percent-MIN_PERCENT)/(MAX_PERCENT-MIN_PERCENT) + MIN_DB
	var bus = (MAX_DB-MIN_DB)*(percent-MIN_PERCENT)/(MAX_PERCENT-MIN_PERCENT) + MIN_DB
	return bus
