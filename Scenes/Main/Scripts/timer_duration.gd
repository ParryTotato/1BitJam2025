class_name TimerDuration
extends Timer

const DEFAULT_DURATION: float = 4

var duration_per_upgrade: float = 2.0

@onready var td_label: Label = $TimerDurationLabel


func _ready() -> void:
	wait_time = DEFAULT_DURATION
	
	Messenger.timer_duration_upgraded.connect(_on_timer_duration_upgraded)
	Messenger.upgrades_refunded.connect(_on_upgrades_refunded)
	#Messenger.upgrades_verified.connect()


func _process(_delta: float) -> void:
	td_label.text = "%d:%02d" % [floor(time_left / 60), int(time_left) % 60]
	

func _on_timer_duration_upgraded() -> void:
	wait_time += duration_per_upgrade


func _on_upgrades_refunded() -> void:
	wait_time = DEFAULT_DURATION
