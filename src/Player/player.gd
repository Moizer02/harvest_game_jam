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

func movement_handler(delta):
	var input_direction = Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	self.velocity = input_direction * (speed * 100) * delta
	if self.move_and_slide():
		var col = get_last_slide_collision().get_collider()
		if col.has_method("Kill"):
			col.Kill()


## Give the player's inventory an item.
## @param newItem - the item's string name.
## @param amount - how many to add.
func AddItem(newItem:String, amount:int=1):
	if inventory.has(newItem):
		inventory[newItem].val += amount
	else:
		inventory[newItem] = {"val": amount}
