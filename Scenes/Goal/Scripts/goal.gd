class_name Goal
extends Area2D

var filled: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body is Box:
		filled = true
		Messenger.goal_filled.emit()


func _on_body_exited(body: Node2D) -> void:
	if body is Box:
		filled = false
		
