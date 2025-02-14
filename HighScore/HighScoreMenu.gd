extends Control


const row = preload("res://HighScore/HighScoreDisplayRow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	populate_high_scores()
	#	DEBUG: for testing wiping leaderboard
#	SilentWolf.Scores.wipe_leaderboard()

func populate_high_scores():
	for child in $CanvasLayer/Menu/Panel2/Panel2/VBoxContainer.get_children():
		child.queue_free()
		
	$CanvasLayer/AmountScoredLabel.text = str(Game.score)
		
	$CanvasLayer/Menu/Panel2/Panel2/LoadingLabel.visible = true
	yield(SilentWolf.Scores.get_high_scores(), "sw_scores_received")

	var idx=1
	print("here are scores", SilentWolf.Scores.scores)
	for score in SilentWolf.Scores.scores:
		var i=row.instance()
		i.get_node("Placement").text='#'+str(idx)
		i.get_node('Name').text=score.player_name
		i.get_node('Score').text=str(score.score)
		$CanvasLayer/Menu/Panel2/Panel2/VBoxContainer.add_child(i)
		idx+=1
	$CanvasLayer/Menu/Panel2/Panel2/LoadingLabel.visible = false
	
	yield(SilentWolf.Scores.get_score_position(Game.score), "sw_position_received")
	print("here is ranking", SilentWolf.Scores.position)
	$CanvasLayer/RankingLabel.text = "Ranked position " + str(SilentWolf.Scores.position) + " overall"

func _on_SubmitButton_pressed():
	if $CanvasLayer/Menu/Panel3/LineEdit.text!='':
		$CanvasLayer/SubmitButton.disabled = true
		var score_id = yield(SilentWolf.Scores.persist_score($CanvasLayer/Menu/Panel3/LineEdit.text, Game.score), "sw_score_posted")
		Game.scoreId=score_id
		print_debug("Score persisted successfully: " + str(score_id))
		Game.goToTitle()
