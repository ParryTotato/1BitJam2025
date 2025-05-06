class_name Coin
extends Area2D

#TODO: Alter via upgrades
#@export var coin_value := 1

#var is_collected := false

func _ready():
	#body_entered.connect(_on_body_entered)
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
	queue_free()
