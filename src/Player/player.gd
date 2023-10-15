extends Node2D

@export var speed = 80

@onready var character_body = $CharacterBody2D

func _ready():
	pass


func _physics_process(delta):
	get_input(delta)
	character_body.move_and_slide()

func get_input(delta):
	var input_direction = Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	character_body.velocity = input_direction * (speed * 100) * delta
