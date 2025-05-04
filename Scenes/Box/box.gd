extends CharacterBody2D

signal push_completed
var being_pushed = false

func push(direction: Vector2, pusher: Node):
	if being_pushed:
		return false
	being_pushed = true
	var tween = create_tween()
	tween.tween_property(self, "position", position + direction * 64, 0.5)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1).from(Vector2(1.1, 0.9))
	tween.finished.connect(_on_push_complete, CONNECT_ONE_SHOT)
	
	return true

func _on_push_complete():
	being_pushed = false
	emit_signal("push_completed")
