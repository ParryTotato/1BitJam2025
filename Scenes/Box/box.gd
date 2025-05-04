extends CharacterBody2D

signal push_completed

var grid_size = 16
var being_pushed = false

func push(direction: Vector2, pusher: Node) -> bool:
	if being_pushed:
		return false
	being_pushed = true
	
	var target_pos = position + (direction.normalized() * grid_size)
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, target_pos, collision_mask, [self, pusher])
	var result = space_state.intersect_ray(query)
	
	if result:
		being_pushed = false
		return false
	
	# Move the box
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, 0.2)
	tween.finished.connect(_on_push_complete)
	return true

func _on_push_complete():
	being_pushed = false
	emit_signal("push_completed")
