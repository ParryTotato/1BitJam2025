class_name Box
extends CharacterBody2D

signal push_completed

var grid_size = 64
var being_pushed = false

func push(direction: Vector2, pusher: Node, kick_boots_active: bool) -> bool:
	if being_pushed:
		return false
	being_pushed = true
	var push_distance = direction.normalized() * grid_size * (3 if kick_boots_active else 1)
	var target_pos = position + push_distance
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, target_pos, collision_mask, [self, pusher])
	var result = space_state.intersect_ray(query)
	
	if result:
		if kick_boots_active:
			target_pos -= direction.normalized() * grid_size
			query = PhysicsRayQueryParameters2D.create(position, target_pos, collision_mask, [self, pusher])
			result = space_state.intersect_ray(query)
			if result:
				target_pos -= direction.normalized() * grid_size
				query = PhysicsRayQueryParameters2D.create(position, target_pos, collision_mask, [self, pusher])
				result = space_state.intersect_ray(query)
				if !result:
					move_box_success(target_pos, 0.4)
					return true
			move_box_success(target_pos, 0.4)
			return true
		being_pushed = false
		return false
	
	# Move the box
	move_box_success(target_pos, 0.2)
	return true

func _on_push_complete():
	being_pushed = false
	emit_signal("push_completed")
	
func pull(direction: Vector2, puller: Node):
	if being_pushed:
		return false
	being_pushed = true
	
	var pull_distance = direction.normalized() * grid_size
	var target_pos = puller.position + pull_distance
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		position, 
		target_pos,
		collision_mask,
		[self, puller]
	)
	var result = space_state.intersect_ray(query)
	
	if result:
		being_pushed = false
		return false
	
	move_box_success(target_pos, 0.4)
	
func move_box_success(target_pos: Vector2, time_to_move: float):
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, time_to_move)
	tween.finished.connect(_on_push_complete)
