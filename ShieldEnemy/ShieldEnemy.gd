extends Enemy

var inherited_scale = 1

func _ready():
	inherited_scale = sign(scale.x)

func _on_Hurtbox_on_damagers_changed(new_damagers : Array, action : Dictionary = {'added': null, 'removed': null}):
#	Only hurt from behind
	if action.added && sign(action.added.global_position.x - global_position.x) == -inherited_scale:
		hurt(action.added.damage)
