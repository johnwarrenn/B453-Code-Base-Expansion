extends KinematicBody2D
class_name Character


# Declare member variables here. Examples:
# var a = 2
# var b = "text"a

var max_xspeed_ps : float = 3000
var	cur_xspeed_ps : float = 0
var inc_xspeed_ps : float = max_xspeed_ps/3
var frict_xspeed_ps : float = inc_xspeed_ps/2
var is_dashing : bool = false
var dash_speed : float = 4000
var jump_speed : float = 3250
var	cur_yspeed_ps : float = 0
var max_yspeed_ps : float = global.GRAVITY_PS
var inc_yspeed_ps : float = max_yspeed_ps/6
var can_dash : float = true
var is_attacking : bool = false
var knocked_back : bool = false
var knocked_back_speed : float = 4000
var knocked_back_air_speed : float = 1500
var can_attack : float = true
var dash_dir : int = 1
var is_knockback_frozen : bool = false
var knocked_back_dir : int = 0
var dir : int = 1; # -1 or 1
var is_jump_held : bool = false # holding jump key
var jump_started : bool = false 
export(int) var max_jumps : int = 1
var jumps_left : int = max_jumps
var iframe_sources : Dictionary = {"debuff": false, "dash": false}
export(float) var life : float = 3
export(PackedScene) var basic_attack_template;
signal spawned(character)
signal died(character)

signal hp_changed(new_hp)

func _init():
	connect("spawned", Game, "_on_player_spawned")
	connect("died", Game, "_on_player_died")
	connect("hp_changed", HUD, "set_hp")
	GInput.connect("action_pressed", self, "basic_attack")
	GInput.connect("dash_pressed", self, "dash")
	GInput.connect("jump_pressed", self, "start_jump")
	GInput.connect("jump_released", self, "stop_jump")
	emit_signal("hp_changed", life)
	
func _ready():
	emit_signal("spawned", self)
	
func _process(delta):
	if is_attacking:
		$AnimationPlayer.play("attack")
	elif is_dashing:
		$AnimatedSprite.play("roll")
	elif is_in_hurt_animation():
		$AnimatedSprite.play("hurt")
	elif (cur_xspeed_ps == 0 && cur_yspeed_ps == 0):
		$AnimatedSprite.play("idle")
	elif (abs(cur_xspeed_ps) > 0 && is_on_floor()):
		$AnimatedSprite.play("run")
#	elif jump_will_start:
#		$AnimatedSprite.play("jumpBefore")
	elif jump_started:
		var apex = 1500
		if cur_yspeed_ps <= -apex :
			$AnimatedSprite.play("jumpRising")
		elif abs(cur_yspeed_ps) < apex :
			$AnimatedSprite.play("jumpApex")
		elif cur_yspeed_ps >= apex :
			$AnimatedSprite.play("jumpFalling")
#	elif jump_endedt:
#		$AnimatedSprite.play("jumpLanding")

func _physics_process(delta):
#	Restore jumps if back on floor
	if is_on_floor() && !is_jump_held:
		jumps_left = max_jumps
		jump_started = false
	
	#set dir if changed direction
	if dir == GInput.xdir*(-1):
		set_player_dir(1 if GInput.xdir  >= 0 else -1)
	var _spd = move_and_slide(Vector2(calc_xspeed(),calc_yspeed()),global.UP,true)
	cur_xspeed_ps = _spd.x
	cur_yspeed_ps = _spd.y

func basic_attack():
	if !is_attacking && !is_dashing && can_attack && is_on_floor():
	#	var _atk = Debris.create_object_at_location(basic_attack_template, global_position)
	#	_atk.scale.x = dir
	#	TODO: change later to be independent, not a child
		var _object : Node = basic_attack_template.instance()
		add_child(_object)
		_object.set_as_toplevel(true)
		_object.global_position = global_position 
		_object.scale.x = dir
		is_attacking = true
		$AttackTimer.start()
		return _object
	
func calc_yspeed():
	var amount 
	amount = cur_yspeed_ps
	
	## Apply gravity
	if is_jump_held:
		amount = min(amount + global.GRAVITY_PS*0.5, global.MAX_VELOCITY_PS)
	else:
		amount = min(amount + global.GRAVITY_PS, global.MAX_VELOCITY_PS)
	
	cur_yspeed_ps = amount
	return amount
	
func calc_xspeed():
	var amount
	if knocked_back:
		amount = knocked_back_speed*knocked_back_dir
	elif is_knockback_frozen:
		amount = 0
	else:
		if is_dashing:
			amount = (inc_xspeed_ps + dash_speed)*dash_dir
		else:
			amount = clamp(cur_xspeed_ps + (inc_xspeed_ps)*GInput.xdir, -max_xspeed_ps, max_xspeed_ps)*int(!is_attacking)
	
	#Apply friction
	if amount > 0:
		amount = max(0, amount - frict_xspeed_ps)
	else:
		amount = min(0, amount + frict_xspeed_ps)
	
	cur_xspeed_ps = amount
	return amount
	
func dash():
	if can_dash && is_on_floor() && !is_attacking && !is_dashing:
		MusicPlayer.dodge_roll()
		$DashTimer.start()
		is_dashing = true
		iframe_sources.dash = true
		dash_dir = dir
		set_collision_mask(4)

func start_dash_cooldown():
	$DashCooldown.start()
	
func start_knock_back(dir_knocked : int):
	knocked_back_dir = dir_knocked
	knocked_back = true
	cur_yspeed_ps -= knocked_back_air_speed
	$KnockbackTimer.start()

## Flip sprite for direction
func set_player_dir(new_dir : int):
	scale.x *= -1
	dir = new_dir
	print("new dir", dir)
	
func start_jump():
	if jumps_left <= 0 || is_dashing:
		return
	  
	if !is_jump_held && is_on_floor():
		jump_started = true
		is_jump_held = true
		cur_yspeed_ps = -jump_speed
		MusicPlayer.jump()
	#Air jumps
	elif !is_jump_held && !is_on_floor():
		jump_started = true
		is_jump_held = true
		jumps_left -= 1
		cur_yspeed_ps = -jump_speed
		MusicPlayer.jump()
		
#When player lets go of jump button
func stop_jump():
	is_jump_held = false

func hurt (damage :float, knockback_dir):
	if !is_invincible():
		MusicPlayer.player_hit()
		life -= damage
		emit_signal("hp_changed", life)
		iframe_sources.debuff = true
		$DebuffTimer.start()
		$HurtAnimator.play("Hurt")
		if knockback_dir:
			start_knock_back(knockback_dir)
		if life <= 0:
			die()

func is_invincible():
	for val in iframe_sources.values():
		if val:
			return true
	return false

func _on_Hurtbox_on_damagers_changed(new_damagers : Array, action : Dictionary = {'added': null, 'removed': null}):
	if action.added:
		var dir_moved = -sign(action.added.global_position.x - global_position.x)
		hurt(action.added.damage, dir_moved)

func _on_DebuffTimer_timeout():
	iframe_sources.debuff = false

func _on_DashTimer_timeout():
	is_dashing = false
	iframe_sources.dash = false
	set_collision_mask(260)
	start_dash_cooldown()	

func _on_DashCooldown_timeout():
	can_dash = true

func _on_KnockbackTimer_timeout():
	knocked_back = false
	is_knockback_frozen = true
	$KnockbackFreezeTime.start()

func die():
	emit_signal("died", self)
	MusicPlayer.play_death_sound()
	queue_free()
	
func is_in_hurt_animation ():
	return knocked_back || is_knockback_frozen

func _on_AttackTimer_timeout():
	is_attacking = false
	can_attack = false
	$AttackCooldown.start()
	
func _on_AttackCooldown_timeout():
	can_attack = true

func _on_KnockbackFreezeTime_timeout():
	is_knockback_frozen = false
