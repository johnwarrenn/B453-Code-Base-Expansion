extends Camera2D

var target : Character = null
var lerp_amount : float = 0.08

func _init():
	Game.connect("player_spawned", self, "attach_to_player")
	
func _physics_process(delta):
	if is_instance_valid(target):
		global_position.x = lerp(global_position.x, target.global_position.x, lerp_amount)
		global_position.y = lerp(global_position.y, target.global_position.y, lerp_amount)
	
func attach_to_player(player : Character):
	target = player
	global_position = player.global_position
