extends Node2D

@onready var timer := $TimerLabel
@onready var upgrade_shop = $UI/UpgradeShop


func _ready():
	timer.start_timer()
	Messenger.timer_ended.connect(_on_timer_ended)
	#Messenger.game_continued.connect( put callback here )


#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_accept"):
#		upgrade_shop.visible = true

#	if event.is_action_pressed("ui_cancel"):
#		upgrade_shop.visible = false
		
func _on_timer_ended():
	upgrade_shop.visible = true

# TODO add Func for game_continued signal
