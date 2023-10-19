extends StaticBody2D

const DRY_SOIL = preload("res://art/crops-v2/empty-soil-dry.png")
const WET_SOIL = preload("res://art/crops-v2/empty-soil.png")

####		Class Variables			############################################
var withered: float = 0
var speed:Vector2 = Vector2(45.0, 30.0)
var destination:Vector2
var target:Node2D # target is a destination that has something there at the end
var interval:float = randf()
var stateTick:float = randf()
var debounce:bool = false
var bugs:int = 0
var water:float = 100
@export_range(0, 5) var stage:int = 0
@export var stage1:Texture2D
@export var stage2:Texture2D
@export var stage3:Texture2D
@export var stage4:Texture2D
@export var stage5:Texture2D
# Yeah... null isn't needed anymore. I thought I was going to use 0 as bare soil
@onready var map = [null, stage1, stage2, stage3, stage4, stage5]


####		Built-in Functions		############################################
# Called when the node enters the scene tree for the first time.
func _ready():
	_updateSprite()

func _process(delta):
	water = clamp(water - delta*2.0, 0, 100)
	$PlantTendingUI/WaterBar.value = water
	if water < 20:
		$soil.texture = DRY_SOIL
	else:
		$soil.texture = WET_SOIL
	$needwater.visible = water < 50
	
	stateTick += delta * (0.05 + (water/120.0) * (2.0 - clampf(bugs, 0, 2)/2.0))
	if stateTick > 15:
		stateTick = 0
		_grow()
	
	if bugs >= 1 || water <= 0:
		withered = clamp(withered + 5 * delta, 0, 100)
		$PlantTendingUI/WitherBar.value = withered
		if withered == 100:
			self.queue_free()


####		Public Functions		############################################
## Used by bugs to latch onto this plant.
func AddBug(newBug:CharacterBody2D):
	if debounce: return
	debounce = true
	bugs += 1
	newBug.queue_free()
	$infectedFX.emitting = true
	
	await get_tree().create_timer(0.5, false).timeout
	debounce = false
	$PlantTendingUI/BugBar.value = bugs

func GetBugsInfesting() -> int:
	return bugs

## Used by Player to remove any bugs infesting this plant.
func KillBugs():
	bugs = 0
	$infectedFX.emitting = false

## Sow a new seed on this spot to start growing.
func Plant():
	if stage != 0: return
	stage = 1
	_updateSprite()

## Harvest the plant once it is fully ripe.
func Harvest():
	if stage != 4: return
	stage = 5
	_updateSprite()
	await get_tree().create_timer(6, false).timeout
	stage = 0
	_updateSprite()

## Refill the plant's 
func Water(amount:float=100.0) -> void:
	water = clamp(water + amount, 0, 100.0)

####		Private Functions		############################################
func _grow() -> void:
	$PlantTendingUI/HarvestBar.value = stage
	if $PlantTendingUI/HarvestBar.value == 4:
		$PlantTendingUI/HarvestBar/HarvestButton.disabled = false
	if stage == 0:
		pass
	elif stage < 4:
		stage += 1
		$growFX.emitting = true
	_updateSprite()

func _updateSprite():
	$plant.texture = map[stage]

####		Signal Listeners		############################################


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$PlantTendingUI.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$PlantTendingUI.visible = false

func _on_water_button_pressed():
	Water(100)
	$PlantTendingUI/WaterBar.value = water

func _on_bug_button_pressed():
	KillBugs()
	$PlantTendingUI/BugBar.value = bugs

func _on_harvest_button_pressed():
	Harvest()
