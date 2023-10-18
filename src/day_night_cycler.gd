extends Control

@export var is_day: bool = true

@export var day_time: float = 15
@export var night_time: float = 15

func _ready():
	$Timer.start(day_time)

func _process(_delta):
	pass

func _on_timer_timeout():
	match is_day:
		true:
			$Timer.start(night_time)
			$AnimationPlayer.play("day_to_night")
		false:
			$Timer.start(day_time)
			$AnimationPlayer.play("night_to_day")
	is_day = !is_day
