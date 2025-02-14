extends Node2D

export(float) var speed : float = .05

func _ready():
	$AnimationPlayer.play("spin")
	$AnimationPlayer.playback_speed = speed
