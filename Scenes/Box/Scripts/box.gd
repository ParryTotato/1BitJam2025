class_name Box
extends CharacterBody2D

signal push_completed

var grid_size = 64
var being_pushed = false

func push(direction: Vector2, pusher: Node, kick_boots_active: bool) -> bool:
	if being_pushed:
		return false
	
	$AudioStreamPlayer.play()
		
	being_pushed = true
	var push_distance = direction.normalized() * grid_size
	var target_pos = position + push_distance * (3 if kick_boots_active else 1)
	var space_state = get_world_2d().direct_space_state
	
	# Check kick distances in descending order (3 → 2 → 1)
	if kick_boots_active:
		var kick_distances = [3, 2, 1]  # Ordered from longest to shortest
		var found_valid_push = false
		
		for distance in kick_distances:
			var test_pos = position + (push_distance * distance)
			var query = PhysicsRayQueryParameters2D.create(
				position, 
				test_pos,
				collision_mask,
				[self, pusher]
			)
			
			if not space_state.intersect_ray(query):
				target_pos = test_pos
				found_valid_push = true
				break
				
		if not found_valid_push:
			being_pushed = false
			return false
			
		move_box_success(target_pos, 0.4)
		return true
	else:
		# Normal push (1 tile)
		var query = PhysicsRayQueryParameters2D.create(
			position,
			target_pos,
			collision_mask,
			[self, pusher]
		)
		
		if space_state.intersect_ray(query):
			being_pushed = false
			return false
			
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
