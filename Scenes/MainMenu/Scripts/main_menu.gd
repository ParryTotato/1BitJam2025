extends Control

@onready var volume_slider = $VBoxContainer/VolumeSlider
@onready var volume_label = $VBoxContainer/VolumeValueLabel

func _ready():
	var current_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	volume_slider.value = _db_to_percent(current_db)
	volume_label.text = "%d%%" % volume_slider.value

func _on_volume_changed(value: float):
	if value <= 1:
		AudioServer.set_bus_volume_db(0, -80.0)
		volume_label.text = "0%"
		volume_slider.value = 1
		return
		
	var db = _percent_to_db(value)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		db
	)
	volume_label.text = ("%d%%" % value)

func _percent_to_db(percent: float) -> float:
	return linear_to_db(percent / 100.0)

func _db_to_percent(db: float) -> float:
	return clamp(db_to_linear(db) * 100, 0, 100)

func _on_start_game():
	get_parent().get_parent().start_game()

func _on_game_quit():
	get_tree().quit()
