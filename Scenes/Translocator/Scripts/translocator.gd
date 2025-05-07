class_name Translocator
extends Sprite2D

func disappear():
	visible = false
	await get_tree().create_timer(0.2).timeout
	queue_free()
