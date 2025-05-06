class_name UpgradeShop
extends Control

var coin_count: int = 50
var coin_spent: int = 0
var coin_multiplier: int = 1
var coin_mult_per_upgrade_tier: int = 1
var cost_mult_per_upgrade_tier: int = 2

var upgrades_default: Dictionary = {
	"TimerDuration": {"tier": 0, "cap": 10, "cost": 2},
	"CoinMultiplier": {"tier": 0, "cap": 10, "cost": 2},
	"Kick": {"tier": 0, "cap": 1, "cost": 10},
	"Magnet": {"tier": 0, "cap": 1, "cost": 10},
	"Translocator": {"tier": 0, "cap": 1, "cost": 10}
}

var upgrades: Dictionary = {
	"TimerDuration": {"tier": 0, "cap": 0, "cost": 0},
	"CoinMultiplier": {"tier": 0, "cap": 0, "cost": 0},
	"Kick": {"tier": 0, "cap": 0, "cost": 0},
	"Magnet": {"tier": 0, "cap": 0, "cost": 0},
	"Translocator": {"tier": 0, "cap": 0, "cost": 0}
}


func _ready() -> void:	
	for key in upgrades_default.keys():
		upgrades[key] = upgrades_default[key].duplicate(true)

	update_labels()

	Messenger.connect("coin_collected", _on_coin_collected)
	

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
	coin_spent += upgrades[type]["cost"]
	
	upgrades[type]["tier"] += 1
	
	if upgrades[type]["tier"] == upgrades[type]["cap"]:
		#TODO: Find better way to signify max upgrade level
		upgrades[type]["cost"] = NAN
	else:
		upgrades[type]["cost"] *= cost_mult_per_upgrade_tier
	
	print(type + " Tier: " + str(upgrades[type]["tier"]))
	
	update_labels()


func update_labels() -> void:
			$CoinCount.text = str(coin_count)
			
			$VBoxContainer/TimerDuration/TDPrice.text = str(upgrades["TimerDuration"]["cost"])
			$VBoxContainer/TimerDuration/TDTier.text = str(upgrades["TimerDuration"]["tier"]) + "/" + str(upgrades["TimerDuration"]["cap"])
			
			$VBoxContainer/CoinMultiplier/CMPrice.text = str(upgrades["CoinMultiplier"]["cost"])
			$VBoxContainer/CoinMultiplier/CMTier.text = str(upgrades["CoinMultiplier"]["tier"]) + "/" + str(upgrades["CoinMultiplier"]["cap"])
			
			$VBoxContainer/Kick/KickPrice.text = str(upgrades["Kick"]["cost"])
			$VBoxContainer/Kick/KickTier.text = str(upgrades["Kick"]["tier"]) + "/" + str(upgrades["Kick"]["cap"])
			
			$VBoxContainer/Magnet/MagnetPrice.text = str(upgrades["Magnet"]["cost"])
			$VBoxContainer/Magnet/MagnetTier.text = str(upgrades["Magnet"]["tier"]) + "/" + str(upgrades["Magnet"]["cap"])
			
			$VBoxContainer/Translocator/TransPrice.text = str(upgrades["Translocator"]["cost"])
			$VBoxContainer/Translocator/TransTier.text = str(upgrades["Translocator"]["tier"]) + "/" + str(upgrades["Translocator"]["cap"])


#region Buttons
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
	coin_count += coin_spent
	coin_spent = 0
	
	for key in upgrades_default.keys():
		upgrades[key] = upgrades_default[key].duplicate(true)
	
	update_labels()
	
	Messenger.emit_signal("upgrades_refunded")
	

func _on_continue_pressed() -> void:
	pass # Replace with function body.
#endregion


func _on_coin_collected() -> void:
	coin_count += 1 * coin_multiplier
		
	update_labels()
