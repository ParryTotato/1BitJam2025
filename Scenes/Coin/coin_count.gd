extends Label


func _ready() -> void:
	Messenger.coin_count_updated.connect(_on_coin_count_updated)


func _process(_delta: float) -> void:
	pass
	

func _on_coin_count_updated(coin_count: int) -> void:
	text = str(coin_count)
