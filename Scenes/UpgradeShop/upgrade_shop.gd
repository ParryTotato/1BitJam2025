class_name UpgradeShop
extends Control

var coin_count: int = 50
var coin_multiplier: int = 1
var coin_mult_per_upgrade_tier: int = 1
var cost_mult_per_upgrade_tier: int = 2

var upgrades: Dictionary = {
	"TimerDuration": {"tier": 0, "cap": 10, "cost": 2},
	"CoinMultiplier": {"tier": 1, "cap": 11, "cost": 2},
	"Kick": {"tier": 0, "cap": 1, "cost": 10},
	"Magnet": {"tier": 0, "cap": 1, "cost": 10},
	"Translocator": {"tier": 0, "cap": 1, "cost": 10}
}


func _ready() -> void:
	Messenger.connect("coin_collected", _on_coin_collected)
	update_label("CoinCount")
	update_label("TimerDuration")
	update_label("CoinMultiplier")
	update_label("Kick")
	update_label("Magnet")
	update_label("Translocator")


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
	if upgrades[type]["tier"] == upgrades[type]["cap"]:
		#TODO: Find better way to signify max upgrade level
		upgrades[type]["cost"] = NAN
	else:
		upgrades[type]["cost"] *= cost_mult_per_upgrade_tier
	
	print(type + " Tier: " + str(upgrades[type]["tier"]))
	update_label("CoinCount")
	update_label(type)


func update_label(label: String) -> void:
	match label:
		"CoinCount":
			$MarginContainer/CoinCount.text = str(coin_count)
		"TimerDuration":
			$MarginContainer/VBoxContainer/TimerDuration.text = \
			"Timer Upgrade: " + str(upgrades["TimerDuration"]["cost"]) + " coins"
		"CoinMultiplier":
			$MarginContainer/VBoxContainer/CoinMultiplier.text = \
			"Coin Multiplier: " + str(upgrades["CoinMultiplier"]["cost"]) + " coins"
		"Kick":
			$MarginContainer/VBoxContainer/Kick.text = \
			"Kick: " + str(upgrades["Kick"]["cost"]) + " coins"
		"Magnet":
			$MarginContainer/VBoxContainer/Magnet.text = \
			"Magnet: " + str(upgrades["Magnet"]["cost"]) + " coins"
		"Translocator":
			$MarginContainer/VBoxContainer/Translocator.text = \
			"Translocator: " + str(upgrades["Translocator"]["cost"]) + " coins"
		

#region _on_"button"_pressed
func _on_timer_duration_pressed() -> void:
	if valid_purchase("TimerDuration"):
		purchase_upgrade("TimerDuration")
		Messenger.timer_duration_upgraded.emit()


func _on_coin_multiplier_pressed() -> void:
	if valid_purchase("CoinMultiplier"):
		purchase_upgrade("CoinMultiplier")
		coin_multiplier += coin_mult_per_upgrade_tier


func _on_kick_pressed() -> void:
	if valid_purchase("Kick"):
		purchase_upgrade("Kick")
		Messenger.kick_upgraded.emit()


func _on_magnet_pressed() -> void:
	if valid_purchase("Magnet"):
		purchase_upgrade("Magnet")
		Messenger.magnet_upgraded.emit()


func _on_translocator_pressed() -> void:
	if valid_purchase("Translocator"):
		purchase_upgrade("Translocator")
		Messenger.translocator_upgraded.emit()


func _on_refund_pressed() -> void:
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	pass # Replace with function body.
#endregion


func _on_coin_collected() -> void:
	coin_count += 1 * coin_multiplier
		
	update_label("CoinCount")
