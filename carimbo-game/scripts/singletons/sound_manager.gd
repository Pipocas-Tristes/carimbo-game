extends Node

const NUMERO_AUDIOS_SIMULTANEOS = 5

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
