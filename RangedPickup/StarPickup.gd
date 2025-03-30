extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StarPickup_area_entered(area):
	if area.is_in_group("Player"):
		var player = area.get_parent()
		player.can_shoot_stars = true
		GInput.connect("shoot_pressed", player, "throw_star")
		self.queue_free()
