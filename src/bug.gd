extends CharacterBody2D

##		Class Variables			################################################
var speed:Vector2 = Vector2(45.0, 30.0)
var destination:Vector2
var target:Node2D # target is a destination that has something there at the end
var interval:float = randf()


##		Built-in Functions		################################################
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	interval += delta
	if interval > 1.5 and not target:
		interval = 0
		SetDestination(global_position + Vector2(randfn(0, 50), randfn(0, 50)))
		rotation = global_position.angle_to_point(destination) + PI/2.0
	
	var goal:Vector2 = $NavAgent.get_next_path_position()
	var dir = goal - position
	
	if dir.length() > 1:
		velocity = dir.normalized() * speed
	else:
		velocity = Vector2()
	move_and_slide()


##		Public Functions		################################################
# Force me to stop going toward my target, if I have one.
func ClearTarget():
	target = null

# Get my current target object.
func GetTarget():
	return target

# Sets a target object for me to go to.
func SetTarget(tgt:Node2D):
	target = tgt
	SetDestination(tgt.global_position)

# Sets a destination position to go to.
func SetDestination(vec:Vector2):
	destination = vec
	$NavAgent.target_position = vec

# Used to set force a starting position.
# Warning: use sparingly. CAN BREAK KINEMATICS.
func SetPosition(vec:Vector2):
	position = vec
	SetDestination(vec*0.8)


##		Private Functions		################################################
# Look for a new crop to pick as my target.
func _findNewTarget() -> void:
	pass
	var crops = get_tree().current_scene.find_child("crops", true, false)
	var weights = []
	var best = null
	
	if crops:
		for crop in crops.get_children():
			if not crop.has_method("GetBugsInfesting"): continue
			weights[weights.size] = [crop, 
				global_position.distance_to(crop.global_position)/100.0 + crop.GetBugsInfesting()]
		
		for opt in weights:
			if not best or opt[1] > best[1]: best = opt
		
		if best: target = best[0]
