extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	if $PanelContainer/VBoxContainer/LineEdit.text!='':
		var score_id = yield(SilentWolf.Scores.persist_score($PanelContainer/VBoxContainer/LineEdit.text, Game.score), "sw_score_posted")
		Game.scoreId=score_id
		print_debug("Score persisted successfully: " + str(score_id))

#TODO: Use this code in order to submit Position2D
#yield(SilentWolf.Scores.get_score_position(score), "sw_position_received")
#              var position = SilentWolf.Scores.position
