extends Control

var hp : float = 100

func set_hp(new_hp : float):
	hp = new_hp
	$UILayer/Control/AnimatedSprite.visible = true
	$UILayer/Control/Label.visible = true
	$UILayer/Control/scorelabel.visible = true
	$UILayer/Control/scorenum.visible = true
	if hp >= 3:
		$UILayer/Control/AnimatedSprite.play('three')
	elif hp == 2:
		$UILayer/Control/AnimatedSprite.play('two')
	elif hp == 1:
		$UILayer/Control/AnimatedSprite.play('one')
	elif hp == 0:
		$UILayer/Control/AnimatedSprite.hide()
		$UILayer/Control/Label.hide()
		$UILayer/Control/scorelabel.hide()
		$UILayer/Control/scorenum.hide()
		
func set_score(new_score : float):
	$UILayer/Control/scorenum.text = str(new_score)

func show_HUD():
	$UILayer/Control.visible = true
	
func hide_HUD():
	$UILayer/Control.visible = false

func show_escape():
	$UILayer/Control/AnimationPlayer.play("FadeOut")
