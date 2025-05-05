class_name UpgradeShop
extends Control

var coin_count: int = 50
var coin_multiplier: int = 0

var upgrades: Dictionary = {
	"timer_duration": {"tier": 0, "cap": 10},
	"coin_multiplier": {"tier": 0, "cap": 10},
	"kick": {"tier": 0, "cap": 1},
	"magnet": {"tier": 0, "cap": 1},
	"translocator": {"tier": 0, "cap": 1}
}

@onready var coin_count_label: Label = $MarginContainer/CoinCount


func _ready() -> void:
	Messenger.connect("coin_added", _on_coin_added)


func _on_timer_duration_pressed() -> void:
	if coin_count >= 2 and upgrades["timer_duration"]["tier"] <= upgrades["timer_duration"]["cap"]:
		spend_coins(2)
		upgrades["timer_duration"]["tier"] += 1
		Messenger.timer_duration_upgraded.emit()


func _on_coin_multiplier_pressed() -> void:
	if coin_count >= 2:
		spend_coins(2)
		coin_multiplier += 2


func _on_kick_pressed() -> void:
	if coin_count >= 4:
		spend_coins(4)
		Messenger.kick_upgraded.emit()


func _on_magnet_pressed() -> void:
	if coin_count >= 4:
		spend_coins(4)
		Messenger.magnet_upgraded.emit()


func _on_translocator_pressed() -> void:
	if coin_count >= 4:
		spend_coins(4)
		Messenger.translocator_upgraded.emit()


func _on_refund_pressed() -> void:
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	pass # Replace with function body.


func _on_coin_added() -> void:
	if coin_multiplier:
		coin_count += 1 * coin_multiplier
	else:
		coin_count += 1
		
	coin_count_label.text = str(coin_count)


func spend_coins(amount: int) -> void:
	coin_count -= amount
	coin_count_label.text = str(coin_count)
