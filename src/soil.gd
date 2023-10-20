extends StaticBody2D

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


####		Built-in Functions		############################################

# Called when the node enters the scene tree for the first time.
func _ready():
	if contains: Plant(contains)

func _process(delta):
	water = clamp(water - delta*2.0, 0, 100)
	$UI/PlantTendingUI/WaterBar.value = water
	$soil.texture = DRY_SOIL if water < 20 else WET_SOIL
	$needwater.visible = water < 50
	tick = (tick + int(30*delta)) % 10
	if CanAddBug() and tick == 0:
		$PlantTendingUI/WitherBar.value = plant.withered


####		Public Functions		############################################

## Passthrough function to the plant this soil patch contains.
func AddBug(newBug:CharacterBody2D):
	if CanAddBug():
		plant.AddBug(newBug)
		$UI/PlantTendingUI/BugBar.value = plant.GetBugsInfesting()

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
func Plant(newPlant:PackedScene):
	if debounce: return
	debounce = true
	
	# Only plant the new crop if this patch is empty or harvested.
	# @TODO: remove the harvested check once plant harvesting is cleaned up.
	if not plant or plant.has_method("Harvest") and plant.stage != 5:
		plant = newPlant.instantiate()
		
		add_child(plant)
		await get_tree().create_timer(0.01, false).timeout
		if plant.has_method("Plant"):
			plant.Plant()
	
	await get_tree().create_timer(0.3, false).timeout
	debounce = false

## Harvest the plant once it is fully ripe.
func Harvest():
	if debounce or not plant or not plant.has_method("Harvest") or not plant.stage != 4: return
	debounce = true
	var plr = get_tree().current_scene.get_node_or_null("Player")
	
	if not plr:
		push_error("Could not find the player!")
	else:
		plr.AddItem(plant.cropType)
	plant.Harvest()
	$UI/PlantTendingUI/HarvestBar/HarvestButton.disabled = true
	$UI/PlantTendingUI/HarvestBar.value = 0
	
	await get_tree().create_timer(0.3, false).timeout
	debounce = false

## Refill the plant's 
func Water(amount:float=100.0) -> void:
	water = clamp(water + amount, 0, 100.0)


####		Private Functions		############################################
####		Signal Listeners		############################################

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$UI/PlantTendingUI.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$UI/PlantTendingUI.visible = false

func _on_water_button_pressed():
	Water(100)
	$UI/PlantTendingUI/WaterBar.value = water

func _on_bug_button_pressed():
	if CanAddBug():
		plant.KillBugs()
		$UI/PlantTendingUI/BugBar.value = plant.GetBugsInfesting()

func _on_harvest_button_pressed():
	Harvest()
