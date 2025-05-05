class_name UpgradeUI
extends Control


var coin_count: int = 4

@onready var coin_count_label: Label = $CoinCount


func _process(delta: float) -> void:
	coin_count_label.text = "Coin Count: " + str(coin_count)


func _on_timer_upgrade_pressed() -> void:
	coin_count -= 2


func _on_coin_multi_upgrade_pressed() -> void:
	coin_count -= 2


func _on_kick_upgrade_pressed() -> void:
	coin_count -= 2


func _on_magnet_upgrade_pressed() -> void:
	coin_count -= 2


func _on_gun_upgrade_pressed() -> void:
	coin_count -= 2
