extends Node2D

@onready var timer: Timer = $DayNightCycler/Timer

var is_day: bool = true
var cycle_duration = 10

const DAY_TIME: float = 10
const NIGHT_TIME: float = 10

func _ready():
	timer.start(DAY_TIME)

func _process(_delta):
	pass

func _on_night_timer_timeout():
	match is_day:
		true:
			timer.start(NIGHT_TIME)
			$AnimationPlayer.play("night_cycle")
		false:
			timer.start(DAY_TIME)
			$AnimationPlayer.play("day_cycle")
	is_day = !is_day
