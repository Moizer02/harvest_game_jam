extends Panel

signal pressed_seed
signal pressed_water
signal pressed_debug
signal pressed_harvest


func ResetDisplay():
	SetPlanted(false)
	SetHarvest(0)
	SetBugs(0)
	SetWitherText("")
	# Water & Wither is updated by the soil in a process loop

func SetPlanted(isPlanted:bool):
	$VB/HarvestBar.visible = isPlanted
	$VB/HarvestButton.visible = isPlanted
	$VB/spacer.visible = not isPlanted
	$VB/PlantSeed.visible = not isPlanted
	if isPlanted:
		SetName("Pumpkin")
		SetWitherText("Healthy")
	else:
		SetName("Empty Soil")

func SetName(text:String):
	$PlantName.text = text

func SetWitherText(text:String):
	$VB/Wither.text = text

func SetWither(amount:float) -> bool:
	$VB/WitherBar.value = amount
	if amount >= 2.0*$VB/WitherBar.max_value/3.0:
		SetWitherText("Dying")
	elif amount >= $VB/WitherBar.max_value/3.0:
		SetWitherText("Struggling")
	else:
		SetWitherText("Healthy")
	return $VB/WitherBar.value == $VB/WitherBar.max_value

func SetWater(amount:float) -> bool:
	$VB/HB/VBW/WaterBar.value = amount
	return $VB/HB/VBW/WaterBar.value == $VB/HB/VBW/WaterBar.max_value

func SetBugs(amount:float) -> bool:
	$VB/HB/VBB/BugBar.value = amount
	return $VB/HB/VBB/BugBar.value == $VB/HB/VBB/BugBar.max_value

func SetHarvest(amount:int) -> bool:
	$VB/HarvestBar.value = amount
	$VB/HarvestButton.disabled = $VB/HarvestBar.value < $VB/HarvestBar.max_value
	return $VB/HarvestBar.value == $VB/HarvestBar.max_value


func _on_harvest_button_pressed():
	$VB/HarvestBar.visible = false
	$VB/HarvestButton.visible = false
	emit_signal("pressed_harvest")

func _on_bug_button_pressed():
	emit_signal("pressed_debug")

func _on_water_button_pressed():
	emit_signal("pressed_water")

func _on_plant_seed_pressed():
	SetPlanted(true)
	emit_signal("pressed_seed")
