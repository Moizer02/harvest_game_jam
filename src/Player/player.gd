extends CharacterBody2D

@export var speed = 80
var inventory:Dictionary = {
	"harvested": {"val": 0},
	"pumpkinseed": {"val": 1, "max": 1},
	"water": {"val": 5, "max": 5},
}
@onready var dayCycle = get_tree().current_scene.get_node_or_null("DayNightCycler")
var step = {
	"sinceLast": 0.0,
	"interval": 0.38,
	"pitchVari": 0.3,
	"pitch": 1.0,
}
var move_keys:Vector2


func _ready():
	pass

func _physics_process(delta):
	movement_handler(delta)

func _process(delta):
	if move_keys.length() > 0.05:
		step.sinceLast += delta*move_keys.length()
		if step.sinceLast >= step.interval:
			step.sinceLast -= step.interval
			$walk.pitch_scale = step.pitch + randf_range(-step.pitchVari, step.pitchVari)
			$walk.play()
	else:
		step.sinceLast = step.interval
	if is_instance_valid(dayCycle):
		$Flashlight.enabled = not dayCycle.is_day
		$glow.enabled = not dayCycle.is_day
	# Set angle based on velocity (if no mouse available)
	#$Flashlight.rotation = $Flashlight.position.angle_to_point(velocity.normalized()) - PI/2
	$Flashlight.rotation = $Flashlight.position.angle_to_point(get_local_mouse_position()) - PI/2

func movement_handler(delta):
	move_keys = Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	self.velocity = move_keys * (speed * 100) * delta
	if self.move_and_slide():
		var col = get_last_slide_collision().get_collider()
		if col.has_method("Kill"):
			col.Kill()


## Give the player's inventory an item.
## @param itemName - the item's string name.
## @param amount - how many to add.
## @return remainder (for things that have a max limit)
func AddItem(itemName:String, amount:int=1) -> int:
	var unused:int = 0
	
	if inventory.has(itemName):
		if inventory[itemName].has("max"):
			unused = mini(amount, inventory[itemName].max - inventory[itemName].val) - amount
		inventory[itemName].val += amount - unused
	else:
		inventory[itemName] = {"val": amount}
	return unused

## Remove an item from the player's inventory.
## @param itemName - the item's string name.
## @param amount - how many to take.
## @return remainder (if the player had fewer than amount in inventory)
func RemoveItem(itemName:String, amount:int=1) -> int:
	var unused:int = 0
	
	if inventory.has(itemName):
		unused = amount - mini(amount, inventory[itemName].val)
		inventory[itemName].val -= amount + unused
	else:
		unused = amount
	return unused
