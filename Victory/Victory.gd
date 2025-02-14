extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/AnimationPlayer.play("fade")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade":
		$CanvasLayer/AnimationPlayer.play("blink")
		$CanvasLayer/Button.visible = true


func _on_Button_pressed():
	
#	Calculate the high score
#	Time bonus = 100*num secs
#	HP bonus = 10000*num hp
	Game.score += floor(100*Game.timer.time_left + 10000 * HUD.hp/33)
	
	get_tree().change_scene("res://HighScore/HighScoreMenu.tscn")
