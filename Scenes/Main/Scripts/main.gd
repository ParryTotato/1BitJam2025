extends Node2D


@onready var game: Node2D = $Game
@onready var timer: Timer = $TimerDuration
@onready var timer_label: Label = $TimerDuration/TimerDurationLabel
@onready var upgrade_shop: Control = $UI/UpgradeShop


func _ready():
	var level_1 = load("res://Scenes/Levels/Level_1.tscn") as PackedScene
	var level_1_instance = level_1.instantiate()
	game.add_child(level_1_instance)
	
	Messenger.game_continued.connect(_on_game_continued)
	Messenger.level_completed.connect(_on_level_completed)
	Messenger.coin_collected.connect(_on_coin_collected)
	timer.start()


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#upgrade_shop.visible = true
#
	#if event.is_action_pressed("ui_cancel"):
		#upgrade_shop.visible = false

# TODO add Func for game_continued signal


func _on_timer_duration_timeout() -> void:
	if upgrade_shop.visible:
		return
		
	timer_label.visible = false
	
	Messenger.timer_duration_ended.emit()


func _on_game_continued() -> void:
	timer.start()
	timer_label.visible = true
	
	upgrade_shop.visible = false


func _on_level_completed(level_completed: String) -> void:
	upgrade_shop.visible = true
	
	timer.stop()
	timer_label.visible = false
	
	
	match level_completed:
		"Level1":
			load_level("res://Scenes/Levels/level_2.tscn")


func load_level(level: String) -> void:
	for child in game.get_children():
		child.queue_free()
	
	var new_level = load(level) as PackedScene
	var new_level_instance = new_level.instantiate()
	
	game.add_child(new_level_instance)
	Messenger.level_loaded.emit()

func _on_coin_collected():
	$AudioStreamPlayer.play()
