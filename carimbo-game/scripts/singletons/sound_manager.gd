extends Node

var sfx_players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	for i in 5:
		var player = AudioStreamPlayer.new()
		add_child(player)
		sfx_players.append(player)
		
func play_sfx(stream: AudioStream):
	for player in sfx_players:
		if not player.playing:
			player.stream = stream
			player.play()
			return
