extends Node2D

@onready var timer := $Timer

func _ready():
	timer.start_timer()
