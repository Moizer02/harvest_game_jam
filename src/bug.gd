extends CharacterBody2D

enum STATES {
	Idle,
	Search,
	Eat,
	Dead
}

####		Class Variables			############################################
var speed:Vector2 = Vector2(45.0, 30.0)
var destination:Vector2
var target:Node2D # target is a destination that has something there at the end
var interval:float = randf() - 1
var stateTick:float = randf() - 1
var state:STATES = STATES.Idle


####		Built-in Functions		############################################
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	stateTick += delta
	if stateTick > 1:
		stateTick = 0
		_updateState()
	
	# create idle roaming
	if state == STATES.Idle:
		interval += delta
		if interval > 1.5 and not target:
			interval = 0
			SetDestination(global_position + Vector2(randfn(0, 50), randfn(0, 50)))
	
	# movement
	var goal:Vector2 = $NavAgent.get_next_path_position()
	var dir = goal - global_position
	
	rotation = global_position.angle_to_point(destination) + PI/2.0
	if dir.length() > 1:
		velocity = dir.normalized() * speed
	else:
		velocity = Vector2()
	if move_and_slide():
		var col = get_last_slide_collision().get_collider()
		
		if col.name == "Player":
			Kill()
		elif target and is_instance_valid(target) and target == col:
			if col.has_method("AddBug"): col.AddBug(self)


####		Public Functions		############################################
## Force me to stop going toward my target, if I have one.
func ClearTarget():
	target = null

## Get my current target object.
func GetTarget():
	return target

## Sets a target object for me to go to.
func SetTarget(tgt:Node2D):
	target = tgt
	SetDestination(tgt.global_position)

## Sets a destination position to go to.
func SetDestination(vec:Vector2):
	destination = vec
	$NavAgent.target_position = vec

## Used to set force a starting position.
## Warning: use sparingly. CAN BREAK KINEMATICS.
func SetPosition(vec:Vector2):
	position = vec
	SetDestination(vec*0.8)

## Called when the player stomps or kills a moving bug.
func Kill():
	state = STATES.Dead
	interval = 0
	SetDestination(position)
	ClearTarget()
	$CollisionShape2D.disabled = true
	# @TODO: play killed sound effect
	$SplatFX.emitting = true
	
	await get_tree().create_timer(2, false).timeout
	queue_free()


####		Private Functions		############################################
func _updateState() -> void:
	if state == STATES.Idle:
		_findNewTarget()
	if state == STATES.Search:
		_findNewTarget()

# Look for a new crop to pick as my target.
func _findNewTarget() -> void:
	var crops = get_tree().current_scene.find_child("plants", true, false)
	var weights = []
	var best = null
	
	if crops:
		for crop in crops.get_children():
			if not crop.has_method("GetBugsInfesting"): continue
			weights.append([crop, 
				global_position.distance_to(crop.global_position)/20.0 + 30*crop.GetBugsInfesting()])
		
		for opt in weights:
			if not best or opt[1] < best[1]: best = opt
		
		if best:
			SetTarget(best[0])
			state = STATES.Search

####		Signal Listeners		############################################
