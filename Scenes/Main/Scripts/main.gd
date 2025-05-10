extends Node2D


@onready var game: Node2D = $Game
@onready var coin_symbol : Sprite2D = $Coin
@onready var coin_label : Label = $CoinCountLabel
@onready var timer: Timer = $TimerDuration
@onready var timer_label: Label = $TimerDuration/TimerDurationLabel
@onready var upgrade_shop: Control = $UI/UpgradeShop
@onready var main_menu: Control = $UI/MainMenu

const MAIN_MENU_SCENE = preload("res://Scenes/MainMenu/main_menu.tscn") as PackedScene

func _ready():
	show_main_menu()
	
	Messenger.game_continued.connect(_on_game_continued)
	Messenger.level_completed.connect(_on_level_completed)
	Messenger.coin_collected.connect(_on_coin_collected)
	Messenger.level_reset.connect(_on_level_reset)

func show_main_menu():
	timer_label.visible = false
	coin_symbol.visible = false
	coin_label.visible = false
	main_menu.visible = true
	upgrade_shop.visible = false
	game.visible = false

func start_game() -> void:
	main_menu.visible = false
	game.visible = true
	
	load_level("res://Scenes/Levels/Level_1.tscn")
	timer.start()
	timer_label.visible = true
	coin_symbol.visible = true
	coin_label.visible = true

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
		"Level2":
			load_level("res://Scenes/Levels/level_3.tscn")
		"Level3":
			load_level("res://Scenes/Levels/level_4.tscn")
		"Level7":
			load_level("res://Scenes/Levels/level_8.tscn")


func load_level(level: String) -> void:
	for child in game.get_children():
		child.queue_free()
	
	await get_tree().process_frame
	
	var new_level = load(level) as PackedScene
	var new_level_instance = new_level.instantiate()
	
	game.add_child(new_level_instance)
	Messenger.level_loaded.emit()

func _on_coin_collected():
	$CoinCollectSound.play()

func _on_level_reset():
	timer.start()
