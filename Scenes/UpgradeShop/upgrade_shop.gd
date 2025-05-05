class_name UpgradeShop
extends Control

var coin_count: int = GlobalGame.coins
var timer_count: int = 4
var coin_multi: int = 0
var bought_kick: bool = false
var bought_magnet: bool = false
var bought_gun: bool = false

@onready var coin_label: Label = $PlayerCoin
@onready var timer_label: Label = $PlayerStats/PlayerTimer
@onready var coin_multi_label: Label = $PlayerStats/CoinMultiUpgrade
@onready var kick_label: Label = $PlayerStats/KickUpgrade
@onready var magnet_label: Label = $PlayerStats/MagnetUpgrade
@onready var gun_label: Label = $PlayerStats/GunUpgrade


func _process(delta: float) -> void:
	coin_label.text = "Coin: " + str(coin_count)
	timer_label.text = "Timer: " + str(timer_count)
	coin_multi_label.text = "Coin Multi: " + str(coin_multi)
	
	if bought_kick:
		kick_label.text = "Bought Kick"
	
	if bought_magnet:
		magnet_label.text = "Bought Magnet"
	
	if bought_gun:
		gun_label.text = "Bought Gun"
		
	coin_count = GlobalGame.coins


func _on_timer_upgrade_pressed() -> void:
	if validate_coin_count():
		coin_count -= 2
		timer_count += 2


func _on_coin_multi_upgrade_pressed() -> void:
	if validate_coin_count():
		coin_count -= 2
		coin_multi += 2
	

func _on_kick_upgrade_pressed() -> void:
	if validate_coin_count() and not bought_kick:
		coin_count -= 1
		bought_kick = true


func _on_magnet_upgrade_pressed() -> void:
	if validate_coin_count() and not bought_magnet:
		coin_count -= 2
		bought_magnet = true


func _on_gun_upgrade_pressed() -> void:
	if validate_coin_count() and not bought_gun:
		coin_count -= 2
		bought_gun = true


func validate_coin_count() -> bool:
	if coin_count > 0:
		return true
	 
	return false
	
