extends StaticBody2D

enum STATES {
	Idle,
	Search,
	Eat,
	Dead
}

##		Class Variables			################################################
var speed:Vector2 = Vector2(45.0, 30.0)
var destination:Vector2
var target:Node2D # target is a destination that has something there at the end
var interval:float = randf()
var stateTick:float = randf()
var debounce:bool = false
@export var state:STATES = STATES.Idle
@export var bugs:int = 0


##		Built-in Functions		################################################
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	stateTick += delta
	if stateTick > 2:
		_updateState()
	
	# despawn
	if state == STATES.Dead:
		interval += delta
		if interval > 5:
			queue_free()


##		Public Functions		################################################
# Used by bugs to latch onto this plant.
func AddBug(newBug:CharacterBody2D):
	if debounce: return
	debounce = true
	bugs += 1
	newBug.queue_free()
	$infected.emitting = true
	
	await get_tree().create_timer(0.5, false).timeout
	debounce = false

func GetBugsInfesting() -> int:
	return bugs

func KillBugs():
	bugs = 0
	$infected.emitting = false

##		Private Functions		################################################
func _updateState() -> void:
	if state == STATES.Search:
		pass

##		Signal Listeners		################################################
func _onBodyEntered(body:CollisionObject2D):
	if target and is_instance_valid(target) and target == body:
		if body.has_method("AddBug"): body.AddBug(self)

func _onBodyExited(body:CollisionObject2D):
	pass
