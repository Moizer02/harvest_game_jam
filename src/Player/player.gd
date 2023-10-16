extends CharacterBody2D

@export var speed = 80

func _ready():
	pass

func _physics_process(delta):
	movement_handler(delta)

func movement_handler(delta):
	var input_direction = Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	self.velocity = input_direction * (speed * 100) * delta
	if self.move_and_slide():
		var col = get_last_slide_collision().get_collider()
		if col.has_method("Kill"):
			col.Kill()
