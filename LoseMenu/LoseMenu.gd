extends Control

func _on_TextureButton_pressed():
	Game.restart()
	$CanvasLayer/Control.release_focus()
	$CanvasLayer/Control.visible = false
	$AnimationPlayer.play("rest")

func toggle_visible():
	$CanvasLayer/Control.visible = true
	$AnimationPlayer.play("death")
	

