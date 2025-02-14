extends Control

const row = preload("res://HighScore/HighScoreDisplayRow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	populate_high_scores()

func populate_high_scores():
	for child in $ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
		
	$LoadingMessage.visible = true
	yield(SilentWolf.Scores.get_high_scores(), "sw_scores_received")

	var idx=1
	print("here are scores", SilentWolf.Scores.scores)
	for score in SilentWolf.Scores.scores:
		var i=row.instance()
#		i.get_node("Placement").text='#'+str(idx)
#		i.get_node('Name').text=score.player_name
#		i.get_node('Score').text=str(score.score)
		$ScrollContainer/VBoxContainer.add_child(i)
		idx+=1
	$LoadingMessage.visible = false
