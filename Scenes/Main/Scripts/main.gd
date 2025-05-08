extends Node2D

@onready var timer := $TimerDuration
@onready var upgrade_shop = $UI/UpgradeShop


func _ready():
	#Messenger.game_continued.connect( put callback here )
	timer.start()


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#upgrade_shop.visible = true
#
	#if event.is_action_pressed("ui_cancel"):
		#upgrade_shop.visible = false

# TODO add Func for game_continued signal
