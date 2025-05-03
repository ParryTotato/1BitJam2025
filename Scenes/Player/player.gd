extends CharacterBody2D

@export var speed = 150
var last_direction = ""

func _physics_process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir.normalized() * speed
	
	# Animation Handling
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
	elif input_dir == Vector2.ZERO and last_direction != "idle":
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0
		last_direction = "idle"
	
	move_and_slide()
	
	# Collision Handling
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var node = collision.get_collider()
		if node.has_method("push"):
			node.push()
