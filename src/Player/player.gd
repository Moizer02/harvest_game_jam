extends CharacterBody2D

# Screenshot
@export var ScreenshotPath: String = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)


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
@export var debug = false


func _ready():
	if debug: $fps.visible = true

func _physics_process(delta):
	movement_handler(delta)

func _process(delta):
	if debug: $fps.text = str(Engine.get_frames_per_second())
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
	# Set angle based on velocity (if no mouse available)
	#$Flashlight.rotation = $Flashlight.position.angle_to_point(velocity.normalized()) - PI/2
	$Flashlight.rotation = $Flashlight.position.angle_to_point(get_local_mouse_position()) - PI/2

func _input(event):
	screenshot_handler(event)

func screenshot_handler(event):
	if event.is_action_pressed("screenshot"):
		var milis = Time.get_unix_time_from_system()
		var d = Time.get_datetime_dict_from_unix_time(milis)
		var texture = get_viewport().get_texture()
		var image = texture.get_image()
		var fn = "GWJ62_%d-%s-%d_%02d%02d%02d.png" % [d.year,d.month,d.day,d.hour,d.minute,d.second]
		
		image.save_png(ScreenshotPath + fn)

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
