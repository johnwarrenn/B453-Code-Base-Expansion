extends KinematicBody2D

export(float) var speed : float = 1000
export(float) var dir : float = 1

func _on_WallDetector_body_entered(body):
	queue_free()
	
func _physics_process(delta):
	move_and_slide(Vector2(speed*dir, 0), global.UP)

func _on_LifeTimer_timeout():
	queue_free()
