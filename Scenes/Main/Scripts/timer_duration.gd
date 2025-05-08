class_name TimerDuration
extends Timer

@onready var td_label: Label = $TimerDurationLabel


func _process(_delta: float) -> void:
	td_label.text = "%d:%02d" % [floor(time_left / 60), int(time_left) % 60]
