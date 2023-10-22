extends StaticBody2D
class_name Soil

const DRY_SOIL = preload("res://art/crops-v2/empty-soil-dry.png")
const WET_SOIL = preload("res://art/crops-v2/empty-soil.png")

####		Class Variables			############################################

## Expected values are either Plant.tscn or BugNest.tscn
@export var contains:PackedScene
## The instance of "contains"
var plant = null

## If true, the soil patch will disappear when its plant is gone.
## If false, the soil patch can be re-planted when empty.
@export var oneShot:bool = false
var tick:int = 0
var debounce:bool = false
var water:float = 100
@onready var dayCycle = get_tree().current_scene.get_node_or_null("DayNightCycler")
@onready var ui = $UI/PlantUI


####		Built-in Functions		############################################
func _process(delta):
	if dayCycle and not dayCycle.is_day:
		water = clamp(water + delta, 0, 100)
	else:
		water = clamp(water - delta*2.0, 0, 100)
	ui.SetWater(water)
	$soil.texture = DRY_SOIL if water < 20 else WET_SOIL
	$needwater.visible = water < 50
	if CanAddBug():
		ui.SetWither(plant.withered)


####		Public Functions		############################################

## Passthrough function to the plant this soil patch contains.
func AddBug(newBug:CharacterBody2D):
	if CanAddBug():
		plant.AddBug(newBug)
		ui.SetBugs(plant.GetBugsInfesting())

func GetBugsInfesting() -> int:
	if CanAddBug():
		return plant.GetBugsInfesting()
	else:
		return 0

## Gets whether the plant on this soil can be infected with bugs.
func CanAddBug() -> bool:
	return is_instance_valid(plant) and plant.has_method("AddBug")

## Sow a new seed on this spot to start growing.
## Only works when the plant is empty (growth stage = 0).
func PlantCrop(newPlant:PackedScene=contains):
	if debounce: return
	debounce = true
	
	if not is_instance_valid(plant):
		plant = newPlant.instantiate()
		
		add_child(plant)
		if plant.has_method("Harvest"):
			plant.connect("grew", _on_plant_grew)
			plant.connect("died", _on_plant_died)
			ui.SetPlanted(true)
	
	await get_tree().create_timer(0.3, false).timeout
	debounce = false

## Harvest the plant once it is fully ripe.
func Harvest():
	if debounce or not plant or not plant.has_method("Harvest") or plant.stage != 4: return
	debounce = true
	var plr = get_tree().current_scene.get_node_or_null("Player")
	
	if not plr:
		push_error("Could not find the player!")
	else:
		plr.AddItem(plant.cropType)
	plant.Harvest()
	
	await plant.tree_exited
	ui.ResetDisplay()
	debounce = false

## Refill the plant's 
func Water(amount:float=100.0) -> void:
	water = clamp(water + amount, 0, 100.0)


####		Private Functions		############################################
####		Signal Listeners		############################################

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		ui.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		ui.visible = false

func _on_water_button_pressed():
	Water(100)
	ui.SetWater(water)

func _on_bug_button_pressed():
	if CanAddBug():
		plant.KillBugs()
		ui.SetBugs(plant.GetBugsInfesting())

func _on_harvest_button_pressed():
	Harvest()

func _on_plantseed_button_pressed():
	PlantCrop()

func _on_plant_grew(stage):
	ui.SetHarvest(stage)

func _on_plant_died():
	plant.queue_free()
	ui.ResetDisplay()
	# @TODO: replace it with an infested BugNest
