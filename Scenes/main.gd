extends Node2D

@onready var timer := $Level/Timer

func _ready():
	timer.start_timer()
