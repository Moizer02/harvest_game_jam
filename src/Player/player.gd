extends CharacterBody2D

@export var speed = 80
var inventory:Dictionary = {
	"harvested": {"val": 0},
	"pumpkinseed": {"val": 1, "max": 1},
	"water": {"val": 5, "max": 5},
}

func _ready():
	pass

func _physics_process(delta):
	movement_handler(delta)

func _process(delta):
	pass
	#@TODO: Flashlight.angle = angle_to_point(mouse position - Flashlight position)

func movement_handler(delta):
	var input_direction = Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	self.velocity = input_direction * (speed * 100) * delta
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
