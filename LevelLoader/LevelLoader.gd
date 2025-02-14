extends Node

func _ready():
	Game.restart_timer()
	MusicPlayer.play_bg_music()
	HUD.show_HUD()
