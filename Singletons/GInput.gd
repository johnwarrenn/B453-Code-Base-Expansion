extends Node

var xdir : int = 0 setget , get_xdir 
var _left_input : int = 0
var _right_input : int = 0
var paused : bool = false

signal action_pressed
signal dash_pressed
signal jump_pressed
signal jump_released

func get_xdir():
	return _left_input + _right_input

func _input(event : InputEvent):
	if event.is_action("ui_left"):
		if event.is_action_pressed("ui_left"):
			_left_input =  -1
		elif event.is_action_released("ui_left"):
			_left_input = 0
	elif event.is_action("ui_right"):
		if event.is_action_pressed("ui_right"):
			_right_input =  1
		elif event.is_action_released("ui_right"):
			_right_input = 0
	elif event.is_action_pressed("ui_action"):
		emit_signal("action_pressed")
	elif event.is_action_pressed("ui_dash"):
		emit_signal("dash_pressed")
	if event.is_action("ui_jump"):
		if event.is_action_pressed("ui_jump"):
			emit_signal("jump_pressed")
		if event.is_action_released("ui_jump"):
			emit_signal("jump_released")
