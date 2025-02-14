extends Enemy

export(PackedScene) var ninja_star_template;
var active : bool = false
var inherited_scale = 1

func _ready():
	inherited_scale = sign(scale.x)

func _physics_process(delta):
	._physics_process(delta)
	pass
	
func _process(delta):
	if !active:
		$AnimatedSprite.play("default")
	
func spawn_star():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("throw")
	var _object : Node = ninja_star_template.instance()
	add_child(_object)
	_object.set_as_toplevel(true)
	_object.global_position = global_position 
	_object.dir = inherited_scale

func _on_Sight_body_entered(body):
	active = true
	spawn_star()
	$NinjaStarSpawner.start()

func _on_Sight_body_exited(body):
	active = false
	$NinjaStarSpawner.stop()

func _on_NinjaStarSpawner_timeout():
	spawn_star()
