extends Node2D

const NEST = preload("res://src/bug_nest.tscn")
const MINUTE:float = 60.0
const HOUR:float = 3600.0

@onready var bugNode = get_node_or_null("bugs")
@onready var plantNode = get_node_or_null("plants")
@onready var nestNode = get_node_or_null("nests")
@onready var player = get_node_or_null("Player")
var clock:float = 0
var checkpoints = {
	"Harvest3": false,
}
var forests = [
	Vector2(816, -729),
	Vector2(-1950, 25),
	Vector2(-4556, -2344),
]

## Max distance away from the center of a forest that a BugNest can spawn.
@export var nestRadius:int = 400


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if checkpoints.Harvest3:
		var nestCount = nestNode.get_child_count()
		
		clock += delta
		if clock >= 15 * MINUTE and nestCount < 9:
			_spawnNests(3)
		elif clock >= 10 * MINUTE and nestCount < 6:
			_spawnNests(3)
		elif nestCount < 3:
			_spawnNests(3)


func _spawnNests(num:int=1):
	for i in range(0, num):
		if not nestNode: return
		var newNest = NEST.instantiate()
		
		nestNode.add_child(newNest)
		newNest.position = forests[randi_range(0, forests.size()-1)] + Vector2(randi_range(-nestRadius, nestRadius), randi_range(-nestRadius, nestRadius))

func _onPlayerInventoryUpdated(type, value):
	if value >= 3 and not checkpoints.Harvest3:
		checkpoints.Harvest3 = true
	$UIHub/MarketUI.UpdateStock(type, value)
