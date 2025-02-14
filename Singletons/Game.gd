extends Node

signal player_spawned(player)
signal player_died(player)

var apiKey = ""
var score = 0
var scoreId = ""
var timer = null

func restart_timer():
	if is_instance_valid(timer):
		timer.queue_free()
	
	var _timer : Timer = Timer.new()
	_timer.autostart = true
	_timer.wait_time = 300
	timer = _timer
	add_child(_timer)

func _ready():
	var f=File.new()
	f.open('res://apiKey.env',File.READ)
	self.apiKey=f.get_line()
	f.close()

	SilentWolf.configure({
		"api_key": "zRzeVxtpw78mffmgPOlNd3Kn7nCnCkd44ZPcaVJQ",
		"game_id": "SamuraivsNinja",
		"game_version": "1.0",
		"log_level": 1
	})


func _on_player_spawned(player : Character):
	MusicPlayer.play_start_sound()
	emit_signal("player_spawned", player)
	
func _on_player_died(player : Character):
	print("emitting player died")
	emit_signal("player_died", player)

func restart():
	score = 0
	get_tree().reload_current_scene()

func goToTitle():
	get_tree().change_scene("res://MainMenu/MainMenu.tscn")
	MusicPlayer.stop_bg_music()
	HUD.hide_HUD()

func victory():
	get_tree().change_scene("res://Victory/Victory.tscn")
	MusicPlayer.stop_bg_music()
	HUD.hide_HUD()
