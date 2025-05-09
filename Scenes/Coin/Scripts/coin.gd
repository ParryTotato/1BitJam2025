class_name Coin
extends Area2D

var is_collected := false

func _ready():
	body_entered.connect(collect)

func collect(_body: Node2D):
	Messenger.coin_collected.emit()
	$Sprite.visible = false
	$Collision.set_deferred("disabled", true)
	queue_free()

func re_enable_coin():
	# Need to decide if the coin value should be removed or if the coin should be re-enabled at all?
	is_collected = false
	$Sprite.visible = true
	$Collision.set_deferred("disabled", false)
