extends CharacterBody2D

@export var move_speed:= 0.2

#Flags
var grid_size := 64
var is_moving = false
var is_pushing = false
var last_direction = "idle"
var target_position : Vector2
var starting_position : Vector2
var has_kick_boots := false
var has_magnet := false
var has_translocator := false
var push_force = 64

var translocator: Sprite2D = null
const TRANSLOCATOR_SCENE = preload("res://Scenes/Translocator/translocator.tscn") as PackedScene

func _ready():
	starting_position = position
	reset_player()
	Messenger.kick_upgraded.connect(_on_kick_upgraded)
	Messenger.translocator_upgraded.connect(_on_translocator_upgraded)
	Messenger.magnet_upgraded.connect(_on_magnet_upgraded)
	Messenger.upgrades_refunded.connect(_on_upgrades_refunded)
	Messenger.timer_duration_ended.connect(_on_timer_duration_ended)
	Messenger.game_continued.connect(_on_game_continued)
	Messenger.level_loaded.connect(_on_level_loaded)
	
	Messenger.upgrades_verified.connect(_on_upgrades_verified)


func _physics_process(_delta):
	if is_moving or is_pushing:
		return
		
	var input_dir := Vector2.ZERO
	if Input.is_action_pressed("left"):
		input_dir.x = -1
	elif Input.is_action_pressed("right"):
		input_dir.x = 1
	elif Input.is_action_pressed("up"):
		input_dir.y = -1
	elif Input.is_action_pressed("down"):
		input_dir.y = 1
	elif has_translocator and Input.is_action_just_pressed("translocate"):
		handle_translocator()
	elif has_magnet and Input.is_action_just_pressed("magnet"):
		handle_magnet()
		
	if input_dir != Vector2.ZERO:
		var new_target = target_position + (input_dir * grid_size)
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(position, new_target, collision_mask, [self])
		var result = space_state.intersect_ray(query)
		
		_play_move_animation(input_dir)
		# No collision, move normally
		if not result:
			target_position = new_target
			is_moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", target_position, move_speed)
			tween.finished.connect(_on_move_complete)
		# Collision, push time
		elif result.collider.has_method("push"):
			var push_direction = input_dir
			if result.collider.push(push_direction * push_force, self, has_kick_boots):
				is_pushing = true
				result.collider.push_completed.connect(_on_push_complete, CONNECT_ONE_SHOT)
	elif last_direction != "idle":
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 7
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

func get_facing_from_animation() -> Vector2:
	match $AnimatedSprite2D.animation:
		"right": return Vector2.RIGHT
		"left": return Vector2.LEFT
		"up": return Vector2.UP
		"down": return Vector2.DOWN
		_: return Vector2.UP

func _on_move_complete():
	is_moving = false

func _on_push_complete():
	is_pushing = false

func reset_player():
	is_moving = false
	is_pushing = false
	position = starting_position
	target_position = starting_position
	is_moving = false
	reset_translocator()
	force_update_transform()
	
func handle_magnet():
	var pull_direction = get_facing_from_animation()
	var space_state = get_world_2d().direct_space_state
	var check_distance = grid_size * 4
	var check_end = position + (pull_direction * check_distance)
	
	var query = PhysicsRayQueryParameters2D.create(
		position,
		check_end,
		collision_mask,
		[self]
	)
	var result = space_state.intersect_ray(query)
	
	print(result)
	
	if result and result.collider.has_method("pull"):
		result.collider.pull(pull_direction, self)
	
func reset_translocator():
	if translocator != null:
		translocator.disappear()
		translocator = null
	
func handle_translocator():
	if translocator == null:
		translocator = TRANSLOCATOR_SCENE.instantiate()
		translocator.position = position
		get_parent().add_child(translocator)
	else:
		position = translocator.position
		target_position = position
		reset_translocator()
	
func _on_kick_upgraded():
	has_kick_boots = true

func _on_magnet_upgraded():
	has_magnet = true
	
func _on_translocator_upgraded():
	has_translocator = true

func _on_upgrades_refunded():
	has_kick_boots = false
	has_magnet = false
	has_translocator = false

func _on_timer_duration_ended():
	set_physics_process(false)

func _on_game_continued():
	set_physics_process(true)

func _on_level_loaded():
	set_physics_process(true)

func _on_upgrades_verified(upgrades: Dictionary):
	if upgrades["Kick"]["tier"] == 0:
		has_kick_boots = false
	else:
		has_kick_boots = true
		
	if upgrades["Magnet"]["tier"] == 0:
		has_magnet = false
	else:
		has_magnet = true
		
	if upgrades["Translocator"]["tier"] == 0:
		has_translocator = false
	else:
		has_translocator = true
