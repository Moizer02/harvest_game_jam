extends Node2D

####		Class Variables			############################################
var withered: float = 0
var stateTick:float = randf()
var debounce:bool = false
var bugs:int = 0
@export_range(0, 5) var stage:int = 0
@export var stage1:Texture2D
@export var stage2:Texture2D
@export var stage3:Texture2D
@export var stage4:Texture2D
@export var stage5:Texture2D
# Yeah... null isn't needed anymore. I thought I was going to use 0 as bare soil
@onready var map = [null, stage1, stage2, stage3, stage4, stage5]
@onready var dayCycle = get_tree().current_scene.get_node_or_null("DayNightCycler")
@onready var soil = get_parent()


####		Built-in Functions		############################################
# Called when the node enters the scene tree for the first time.
func _ready():
	_updateSprite()

func _process(delta):
	# Throttle growth speed by Water, Bugs, & Light
	if dayCycle and dayCycle.is_day:
		stateTick += delta * (0.05 + (soil.water/120.0) * (2.0 - clampf(bugs, 0, 2)/2.0))
	if stateTick > 15:
		stateTick = 0
		_grow()
	
	if bugs >= 1 or soil.water <= 0:
		withered = clamp(withered + 5 * delta, 0, 100)
		$PlantTendingUI/WitherBar.value = withered
		if withered >= 100:
			withered = 0
			stage = 0
			_updateSprite()
			# @TODO: become an infested BugNest


####		Public Functions		############################################
## Used by bugs to latch onto this plant.
func AddBug(newBug:CharacterBody2D):
	if debounce: return
	debounce = true
	bugs += 1
	newBug.queue_free()
	$infectedFX.emitting = true
	$PlantTendingUI/BugBar.value = bugs
	
	await get_tree().create_timer(0.5, false).timeout
	debounce = false

func GetBugsInfesting() -> int:
	return bugs

## Used by Player to remove any bugs infesting this plant.
func KillBugs():
	bugs = 0
	$infectedFX.emitting = false

## Sow a new seed on this spot to start growing.
## Only works when the plant is empty (growth stage = 0).
func Plant():
	if stage != 0: return
	stage = 0

## Harvest the plant once it is fully ripe.
## @TODO: remove
func Harvest():
	if stage != 4: return
	stage = 5
	_updateSprite()
	await get_tree().create_timer(6, false).timeout
	queue_free()

## Refill the plant's water meter
## @TODO: remove. This belongs in soil.gd
func Water(amount:float=100.0) -> void:
	soil.water = clamp(soil.water + amount, 0, 100.0)

####		Private Functions		############################################
func _grow() -> void:
	var harvestBar = get_node("../UI/PlantTendingUI/HarvestBar")
	
	harvestBar.value = stage
	if harvestBar.value == 4:
		harvestBar.get_node("HarvestButton").disabled = false
	if stage < 4:
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
	$PlantTendingUI/WaterBar.value = soil.water

func _on_bug_button_pressed():
	KillBugs()
	$PlantTendingUI/BugBar.value = bugs

func _on_harvest_button_pressed():
	Harvest()
