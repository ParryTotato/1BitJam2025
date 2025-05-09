extends Control

@onready var volume_slider = $VBoxContainer/VolumeSlider
@onready var volume_label = $VBoxContainer/HBoxContainer/VolumeValueLabel

func _ready():
	# Sets the volume level to the default value of slider (30 at time of writing)
	_on_volume_changed(volume_slider.value)

func _on_volume_changed(value: float):
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
