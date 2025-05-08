extends CharacterBody2D

signal push_completed

var grid_size = 64
var being_pushed = false

func push(direction: Vector2, pusher: Node, kick_boots_active: bool) -> bool:
	if being_pushed:
		return false
	being_pushed = true
	var push_distance = direction.normalized() * grid_size * (2 if kick_boots_active else 1)
	var target_pos = position + push_distance
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, target_pos, collision_mask, [self, pusher])
	var result = space_state.intersect_ray(query)
	
	if result:
		if kick_boots_active:
			target_pos -= direction.normalized() * grid_size
			query = PhysicsRayQueryParameters2D.create(position, target_pos, collision_mask, [self, pusher])
			result = space_state.intersect_ray(query)
			if !result:
				move_box_success(target_pos)
				return true
		being_pushed = false
		return false
	
	# Move the box
	move_box_success(target_pos)
	return true

func _on_push_complete():
	being_pushed = false
	emit_signal("push_completed")
	
func move_box_success(target_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, 0.2)
	tween.finished.connect(_on_push_complete)
