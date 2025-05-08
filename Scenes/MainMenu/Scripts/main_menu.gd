extends Control

func _on_start_game():
	Messenger.game_starting.emit()

func _on_settings_clicked():
	# Do the settings stuff
	pass
	
func _on_game_quit():
	get_tree().quit()
