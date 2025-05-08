class_name Coin
extends Area2D

var is_collected := false

func _ready():
	body_entered.connect(collect)


#func _on_body_entered(body: Node2D):
	#if is_collected: 
		#return
	#
	#if body.is_in_group("player") or body.is_in_group("box"):
		#collect()


func collect(_body: Node2D):
	#is_collected = true
	# Maybe sound for picking up coin?
	#GlobalGame.add_coins(coin_value)
	
	#$Sprite.visible = false
	#$Collision.set_deferred("disabled", true)
	Messenger.coin_collected.emit()
	$Sprite.visible = false
	$Collision.set_deferred("disabled", true)
	queue_free()

func re_enable_coin():
	# Need to decide if the coin value should be removed or if the coin should be re-enabled at all?
	is_collected = false
	$Sprite.visible = true
	$Collision.set_deferred("disabled", false)
