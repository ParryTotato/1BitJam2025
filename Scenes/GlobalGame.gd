extends Node2D

var coins := 0
var upgradeTree = {
	"coin_value": 1.0
}

func add_coins(amount: int):
	coins += amount
	print(coins)
	# Add UI update
