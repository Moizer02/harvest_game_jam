extends Node2D

const NEST = preload("res://src/bug_nest.tscn")

@onready var bugNode = get_node_or_null("bugs")
@onready var plantNode = get_node_or_null("plants")
@onready var nestNode = get_node_or_null("nests")
@onready var player = get_node_or_null("Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _spawnNests(num:int=1):
	for i in range(0, num):
		if not nestNode: return
		var newNest = NEST.instantiate()
		
		nestNode.add_child(newNest)
