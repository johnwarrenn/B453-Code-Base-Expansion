extends Node

func _ready():
	Game.connect("player_died", self, "_on_player_died")

func _on_player_died(character):
	$LoseMenu.toggle_visible()
	
