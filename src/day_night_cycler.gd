extends Control

@export var is_day: bool = true

@export var day_time: float = 30
@export var night_time: float = 20
var light:float


func _ready():
	_on_animation_finished("sunrise")

func _process(_delta):
	light = $DirectionalLight2D.energy
	is_day = light < 0.2

func _on_animation_finished(anim_name):
	# If we're worried about the performance of creating tree timers, we
	# could just edit the animation length instead.
	match anim_name:
		"sunset":
			await get_tree().create_timer(night_time, false).timeout
			$AnimationPlayer.play("sunrise")
		"sunrise":
			await get_tree().create_timer(day_time, false).timeout
			$AnimationPlayer.play("sunset")
