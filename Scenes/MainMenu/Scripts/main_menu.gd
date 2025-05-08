extends Control

@onready var settings_panel = $SettingsPanel

func _ready():
	settings_panel.visible = false
	$SettingsPanel/VolumeSlider.value = \
	db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))*100
	
	$SettingsPanel/VolumeSlider.value_changed.connect(_on_volume_changed)

func _on_start_game():
	get_parent().get_parent().start_game()

func _on_settings_clicked():
	settings_panel.visible = true

func _on_volume_changed(value: float):
	print(value)
	var db = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		db
	)
	$SettingsPanel/VolumeValueLabel.text = "%d%%" % value
	
func _on_settings_back_button_clicked():
	settings_panel.visible = false

func _on_game_quit():
	get_tree().quit()
