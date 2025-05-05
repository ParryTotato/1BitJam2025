class_name UpgradeShop
extends Control

var coin_count: int = 50
var coin_multiplier: int = 0

var upgrades: Dictionary = {
	"timer_duration": {"tier": 0, "cap": 10, "cost": 2},
	"coin_multiplier": {"tier": 0, "cap": 10, "cost": 2},
	"kick": {"tier": 0, "cap": 1, "cost": 10},
	"magnet": {"tier": 0, "cap": 1, "cost": 10},
	"translocator": {"tier": 0, "cap": 1, "cost": 10}
}


func _ready() -> void:
	Messenger.connect("coin_collected", _on_coin_collected)
	update_label("CoinCount")


func valid_purchase(type: String) -> bool:
	if coin_count < upgrades[type]["cost"]:
		print("Not enough coins")
		return false
	
	if upgrades[type]["tier"] == upgrades[type]["cap"]:
		print("Upgrade is capped")
		return false
	
	return true


func purchase_upgrade(type: String) -> void:
	coin_count -= upgrades[type]["cost"]
	upgrades[type]["tier"] += 1
	
	print(type + " Tier: " + str(upgrades[type]["tier"]))
	
	update_label("CoinCount")


func update_label(label: String) -> void:
	match label:
		"CoinCount":
			$MarginContainer/CoinCount.text = str(coin_count)
		

#region _on_"button"_pressed
func _on_timer_duration_pressed() -> void:
	if valid_purchase("timer_duration"):
		purchase_upgrade("timer_duration")
		Messenger.timer_duration_upgraded.emit()


func _on_coin_multiplier_pressed() -> void:
	if valid_purchase("coin_multiplier"):
		purchase_upgrade("coin_multiplier")
		coin_multiplier += 2


func _on_kick_pressed() -> void:
	if valid_purchase("kick"):
		purchase_upgrade("kick")
		Messenger.kick_upgraded.emit()


func _on_magnet_pressed() -> void:
	if valid_purchase("magnet"):
		purchase_upgrade("magnet")
		Messenger.magnet_upgraded.emit()


func _on_translocator_pressed() -> void:
	if valid_purchase("translocator"):
		purchase_upgrade("translocator")
		Messenger.translocator_upgraded.emit()


func _on_refund_pressed() -> void:
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	pass # Replace with function body.
#endregion


func _on_coin_collected() -> void:
	if coin_multiplier:
		coin_count += 1 * coin_multiplier
	else:
		coin_count += 1
		
	update_label("CoinCount")
