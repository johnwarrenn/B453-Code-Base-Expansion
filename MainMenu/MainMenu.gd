extends Node2D

onready var Controls = get_node("Controls")

# Called when the node enters the scene tree for the first time.
#func _ready():
#	$AnimationPlayer.play("FadeOut")

func _on_StartButton_pressed():
	get_tree().change_scene("res://LevelLoader/LevelLoader.tscn")
	HUD.show_escape()

func _on_ControlsButton_pressed():
	Controls.visible = !Controls.visible

func _on_QuitButton_pressed():
	get_tree().quit()
	
