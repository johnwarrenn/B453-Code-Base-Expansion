extends Enemy

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_anticipating : bool = false
var is_landing : bool = false
var is_jumping : bool = false
export(float) var jump_yspeed : float = 4250
export(float) var jump_xspeed : float = 3000
var reached_apex : bool = false
var can_jump : bool = true
var target : Character = null
var jump_dir : int = 1

func _process(delta):
	if is_anticipating:
		$AnimationPlayer.play("anticipate")
	elif is_landing:
		$AnimationPlayer.play("jumpLand")
	elif is_jumping:
		var apex = 1500
		if cur_speed.y <= -apex :
			$AnimationPlayer.play("jumpRise")
		elif abs(cur_speed.y) < apex :
			reached_apex = true
			$AnimationPlayer.play("jumpApex")
		elif cur_speed.y >= apex :
			$AnimationPlayer.play("jumpFall")
	else:
		$AnimationPlayer.play("default")
		
#	Chase player
	if target && can_jump:
			jump()

func calc_xspeed():
	if is_jumping:
		if reached_apex && is_on_floor():
			print("ending jump")
			is_jumping = false
			$LandingTime.start()
			is_landing = true
		return jump_xspeed*jump_dir
	else:
		return 0
		
func jump():
	can_jump = false
	is_anticipating = true
	var lastdir = jump_dir
	if is_instance_valid(target):
		jump_dir = 1 if target.global_position.x - global_position.x > 0 else -1
	else:
		jump_dir = 1
	if lastdir != jump_dir:
		scale.x = -1
	scale.x = jump_dir
	$AnticipateTime.start()

#First step of jump
func _on_AnticipateTime_timeout():
	is_anticipating = false
	cur_speed.y -= jump_yspeed
	is_jumping = true
	reached_apex = false

#Last step of jump
func _on_LandingTime_timeout():
	is_landing = false
	can_jump = true

func _on_Sight_body_entered(body):
	target = body

func _on_Sight_body_exited(body):
	target = null
