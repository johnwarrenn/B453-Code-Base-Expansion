extends Enemy


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target : Character = null
var is_attacking : bool = false
export(float) var run_xspeed : float = 2000
var frict_xspeed_ps : float = run_xspeed/24
var target_dir : int = 1
var is_chasing : bool = false
var should_attack : bool = false 
var on_cd : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	if can_attack():
		var last_dir = target_dir
		if is_instance_valid(target):
			target_dir = 1 if sign(target.global_position.x - global_position.x) > 0 else -1
		else:
			target_dir = last_dir
		if last_dir != target_dir:
			scale.x = -1
		if should_attack:
			attack()

func _process(delta):
	if is_attacking:
		$AnimationPlayer.play("attack")
	elif is_chasing && !on_cd:
		$AnimationPlayer.play("run")
	else:
		$AnimationPlayer.play("default")

func attack():
	is_attacking = true
	$AttackLengthTimer.start()
	
func calc_xspeed():
	if on_cd:
		return 0
	if is_attacking:
		if cur_speed.x > 0:
			return max(cur_speed.x - frict_xspeed_ps, 0)
		elif cur_speed.x <= 0:
			return min(cur_speed.x + frict_xspeed_ps, 0)
	elif is_chasing:
		return run_xspeed*target_dir
	else:
		return 0

func _on_Area2D_body_entered(body):
	target = body
	is_chasing = true

func _on_Area2D_body_exited(body):
	target = null
	is_chasing = false
	
	#Dive forward on leave
	if can_attack():
		attack()

func _on_AttackCDTimer_timeout():
	on_cd = false

func _on_StrikingDistance_body_entered(body):
	should_attack = true

func _on_StrikingDistance_body_exited(body):
	should_attack = false

func _on_AttackLengthTimer_timeout():
	is_attacking = false
	on_cd = true
	$AttackCDTimer.start()

func can_attack():
	return !on_cd && !is_attacking
