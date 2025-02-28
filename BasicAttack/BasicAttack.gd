extends Node2D

func _on_Hitbox_tree_exiting():
	queue_free()
