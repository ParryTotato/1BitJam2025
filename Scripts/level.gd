class_name Level
extends TileMapLayer

var original_positions := {}


func _ready():
	_register_objects()

	
func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		reset_level()
	
	
func _register_objects():
	for child in get_children(true):
		if child is CharacterBody2D or child is Area2D:
			original_positions[child.name] = child.position


func reset_level():
	set_physics_process(false)
	for child in get_children():
		if child.name in original_positions:
			child.position = original_positions[child.name]
			
			if child.has_method("reset_player"):
				child.reset_player()
			
			if child.has_method("re_enable_coin"):
				child.re_enable_coin()
	set_physics_process(true)
