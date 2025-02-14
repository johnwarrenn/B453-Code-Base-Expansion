extends Control

var active : bool = false
signal toggle_visibility(visible)

func enable():
	active = true
	get_tree().paused = true
	$CanvasLayer/Menu.visible = true
	
func disable():
	get_tree().paused = false
	active = false
	$CanvasLayer/Menu.visible = false

func _input(event : InputEvent):
	if event.is_action_pressed("ui_pause") && active:
		disable()
			
	elif event.is_action_pressed("ui_pause") && !active:
		enable()



func _on_Restart_pressed():
	Game.restart()
	disable()

func _on_Resume_pressed():
	disable()

func _on_MainMenu_pressed():
	Game.goToTitle()
	disable()
