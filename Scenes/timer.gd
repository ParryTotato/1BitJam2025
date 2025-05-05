extends CanvasLayer

@export var initial_time: float = 30.0

var time_left: float = initial_time
var timer_active := false

@onready var timer_label := $Label

func _ready():
	start_timer()
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
	timer_label.text = "%2d:%02d" % [minutes, seconds]

func start_timer():
	timer_active = true

func pause_timer():
	timer_active = false

func timer_ended():
	timer_active = false
	timer_label.text = "0:00"
	#TODO: Add game over logic
