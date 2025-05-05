class_name UpgradeShop
extends Control


func _process(delta: float) -> void:
	$CoinCount.text = "Coin Count: " + str(GlobalGame.coins)
	$PlayerStats/Timer.text = "Timer Duration: " + str(GlobalGame.upgradeTree["timer_duration"])
	$PlayerStats/CoinMulti.text = "Coin Multi: " + str(GlobalGame.upgradeTree["coin_multi"])


func _on_timer_upgrade_pressed() -> void:
	if validate_coin_count():
		GlobalGame.coins -= 1
		GlobalGame.upgradeTree["timer_duration"] += 2


func validate_coin_count() -> bool:
	if GlobalGame.coins > 0:
		return true
	 
	return false
	
