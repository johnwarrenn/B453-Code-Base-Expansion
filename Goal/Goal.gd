extends Node2D

func _ready():
	hide()

func _on_Area2D_body_entered(body):
	$AnimationPlayer.play("New Anim")
	
func play_yatta():
	MusicPlayer.play_yabai()
	
func go_to_next_room():
	Game.victory()
