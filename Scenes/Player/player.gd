extends CharacterBody2D

@export var speed = 150
var last_direction = ""
var is_pushing = false

# Variables that can be increased via upgrades
var push_force = 64

func _physics_process(delta):
	if is_pushing:
		return
		
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir.normalized() * speed
	
	movement_handling(input_dir)
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var node = collision.get_collider()
		if node.has_method("push"):
			var push_direction = velocity.normalized()
			if node.push(push_direction * push_force * delta, self):
				is_pushing = true
				node.push_completed.connect(reset_push, CONNECT_ONE_SHOT)

func movement_handling(input_dir: Vector2):
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

func reset_push():
	is_pushing = false
