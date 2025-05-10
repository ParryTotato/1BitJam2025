class_name Level
extends TileMapLayer

var original_positions := {}
var goal_count: int
var goals_filled: int


func _ready():
	_register_objects()
	
	Messenger.game_continued.connect(_on_game_continued)
	Messenger.goal_filled.connect(_on_goal_filled)
	Messenger.goal_unfilled.connect(_on_goal_unfilled)

	
func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		reset_level()
	
	if goals_filled == goal_count:
		goals_filled = 0
		Messenger.level_completed.emit(self.name)
		print("level completed")
		
	
func _register_objects():
	for child in get_children(true):
		if child is CharacterBody2D or child is Area2D:
			original_positions[child.name] = child.position

		if child is Goal:
			goal_count += 1

func reset_level():
	Input.action_release("ui_up")
	Input.action_release("ui_down")
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	set_physics_process(false)
	for child in get_children():
		if child.name in original_positions:
			child.position = original_positions[child.name]
			if child.has_method("reset_player"):
				child.reset_player()
	set_physics_process(true)

	goals_filled = 0
	Messenger.level_reset.emit()


func _on_game_continued():
	reset_level()


func _on_goal_filled():
	goals_filled += 1
	print("goal filled")


func _on_goal_unfilled():
	if goals_filled != 0:
		goals_filled -= 1
		print("goal unfilled")
