extends CharacterBody2D

@export var move_speed:= 0.2

#Flags
var grid_size := 16
var is_moving = false
var is_pushing = false
var last_direction = "idle"
var target_position : Vector2

# Variables that can be increased via upgrades
var push_force = 64

func _ready():
	target_position = position

func _physics_process(_delta):
	if is_moving or is_pushing:
		return
		
	var input_dir := Vector2.ZERO
	if Input.is_action_just_pressed("ui_left"):
		input_dir.x = -1
	elif Input.is_action_just_pressed("ui_right"):
		input_dir.x = 1
	elif Input.is_action_just_pressed("ui_up"):
		input_dir.y = -1
	elif Input.is_action_just_pressed("ui_down"):
		input_dir.y = 1
		
	if input_dir != Vector2.ZERO:
		var new_target = target_position + (input_dir * grid_size)
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(position, new_target, collision_mask, [self])
		var result = space_state.intersect_ray(query)
		
		# No collision, move normally
		if not result:
			target_position = new_target
			is_moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", target_position, move_speed)
			tween.finished.connect(_on_move_complete)
			_play_move_animation(input_dir)
		# Collision, push time
		elif result.collider.has_method("push"):
			var push_direction = input_dir
			if result.collider.push(push_direction * push_force, self):
				is_pushing = true
				result.collider.push_completed.connect(_on_push_complete, CONNECT_ONE_SHOT)
	elif last_direction != "idle":
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0
		last_direction = "idle"

func _play_move_animation(input_dir: Vector2):
	if input_dir.x > 0 and last_direction != "right": 
		$AnimatedSprite2D.play("right")
		last_direction = "right"
	elif input_dir.x < 0 and last_direction != "left": 
		$AnimatedSprite2D.play("left")
		last_direction = "left"
	elif input_dir.y < 0 and last_direction != "up": 
		$AnimatedSprite2D.play("up")
		last_direction = "up"
	elif input_dir.y > 0 and last_direction != "down": 
		$AnimatedSprite2D.play("down")
		last_direction = "down"

func _on_move_complete():
	is_moving = false

func _on_push_complete():
	is_pushing = false
