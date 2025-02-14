extends KinematicBody2D
class_name Enemy

export(float) var life : float = 100
var cur_speed : Vector2 = Vector2(0,0) 
export(int) var score : float = 100
export(PackedScene) var particleTemplate

func _physics_process(delta):
	cur_speed = move_and_slide(Vector2(calc_xspeed(),calc_yspeed()),global.UP)
	
func calc_yspeed():
	return min(cur_speed.y + global.GRAVITY_PS, global.MAX_VELOCITY_PS)

func calc_xspeed():
	return 0

func hurt(damage : float):
	$HurtAnimator.play("Hurt")
	life -= damage
	if life <= 0:
		MusicPlayer.play_enemy_kill()
		die()
	else:
		MusicPlayer.enemy_hit()

func _on_Hurtbox_on_damagers_changed(new_damagers : Array, action : Dictionary = {'added': null, 'removed': null}):
	if action.added:
		hurt(action.added.damage)

func die():
	Game.score += score
	HUD.set_score(Game.score)
	queue_free()
