extends Label

@export var initial_time: float = 3.0


var time_left: float = initial_time
var timer_active := false

func _ready():
	update_display()
	
func _process(delta):
	if timer_active and time_left > 0:
		time_left -= delta
		update_display()
		if time_left <= 0:
			timer_ended()

func update_display():
	var minutes: float = floor(time_left / 60)
	var seconds: float = floor(fmod(time_left, 60))
	text = "%2d:%02d" % [minutes, seconds]

func start_timer():
	timer_active = true

func pause_timer():
	timer_active = false

func timer_ended():
	timer_active = false
	text = "0:00"
	Messenger.timer_ended.emit()
	#TODO: Add game over logic
