extends Node2D

####		Class Variables			############################################
## Number of seconds between spawning another bug.
@export var spawnRate:float = 20

## Type of creature to spawn.
@export var entity:PackedScene

var enabled:bool = true
var seconds:float = randf() - 1
@onready var bugContainer:Node2D = get_tree().current_scene.get_node_or_null("bugs")


####		Built-in Functions		############################################
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	seconds += delta
	if seconds >= spawnRate:
		seconds -= spawnRate
		_spawnEntity(2)


####		Public Functions		############################################
## Used by characters to get rid of the nest.
func Destroy():
	enabled = false
	# @TODO: particles / animation when destroyed
	await get_tree().create_timer(1, false).timeout
	queue_free()

####		Private Functions		############################################
func _spawnEntity(num:int=1) -> void:
	if not bugContainer:
		push_error("Scene is missing a bugs container node!")
		return
	elif not entity:
		push_error("No bug for me to spawn!")
		return
	for i in range(0, num):
		var instance = entity.instantiate()
		var offset:Vector2 = Vector2(randf_range(-4.0, 4.0), randf_range(-4.0, 4.0)).normalized() * 10
		
		bugContainer.add_child(instance)
		if instance.has_method("SetPosition"):
			instance.SetPosition(global_position + offset)
		else:
			instance.position = global_position + offset

####		Signal Listeners		############################################
