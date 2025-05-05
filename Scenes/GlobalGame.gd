extends Node2D

var coins: int = 0
var upgradeTree: Dictionary = {
	"timer_duration": 10,
	"coin_multi": 1.0,
	"kick": false,
	"magnet": false,
	"translocator": false
}


func add_coins(amount: int) -> void:
	coins += amount
	print(coins)
	# Add UI update
