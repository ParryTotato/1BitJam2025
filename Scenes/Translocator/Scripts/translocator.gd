class_name Translocator
extends CharacterBody2D

func disappear():
	visible = false
	await get_tree().create_timer(0.2).timeout
	queue_free()
