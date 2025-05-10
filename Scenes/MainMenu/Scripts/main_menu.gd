extends Control

@onready var sfx_volume_slider = $VBoxContainer/SFXVolumeSlider
@onready var sfx_volume_label = $VBoxContainer/HBoxContainer/SFXVolumeValueLabel
@onready var music_volume_slider = $VBoxContainer/MusicVolumeSlider
@onready var music_volume_label = $VBoxContainer/HBoxContainer2/MusicVolumeValueLabel

func _ready():
	# Sets the volume level to the default value of slider
	_on_sfx_volume_changed(sfx_volume_slider.value)
	_on_music_volume_changed(music_volume_slider.value)
	
	$MenuMusic.play()
	$Hourglass.play()

func _on_sfx_volume_changed(value: float):
	_set_audio_level(value, "SFX")
	sfx_volume_label.text = ("%d%%" % value)
	
func _on_music_volume_changed(value: float):
	_set_audio_level(value, "Music")
	music_volume_label.text = ("%d%%" % value)

func _set_audio_level(value: float, bus_name: String):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(bus_name),
		_percent_to_db(value)
	)

func _percent_to_db(percent: float) -> float:
	return linear_to_db(percent / 100.0)

func _on_start_game():
	get_parent().get_parent().start_game()
	$MenuMusic.stop()

func _on_game_quit():
	get_tree().quit()


func _on_play_game_mouse_entered() -> void:
	$UIHover.play()


func _on_sfx_volume_slider_mouse_entered() -> void:
	$UIHover.play()


func _on_music_volume_slider_mouse_entered() -> void:
	$UIHover.play()
