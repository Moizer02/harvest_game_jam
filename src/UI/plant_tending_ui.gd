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
	$HarvestBar.visible = isPlanted
	$PlantSeed.visible = not isPlanted
	if isPlanted:
		SetName("Pumpkin")
		SetWitherText("Healthy")
	else:
		SetName("Empty Soil")

func SetName(text:String):
	$PlantName.text = text

func SetWitherText(text:String):
	$Wither.text = text

func SetWither(amount:float) -> bool:
	$WitherBar.value = amount
	if amount >= 2.0*$WitherBar.max_value/3.0:
		SetWitherText("Dying")
	elif amount >= $WitherBar.max_value/3.0:
		SetWitherText("Struggling")
	else:
		SetWitherText("Healthy")
	return $WitherBar.value == $WitherBar.max_value

func SetWater(amount:float) -> bool:
	$WaterBar.value = amount
	return $WaterBar.value == $WaterBar.max_value

func SetBugs(amount:float) -> bool:
	$BugBar.value = amount
	return $BugBar.value == $BugBar.max_value

func SetHarvest(amount:int) -> bool:
	$HarvestBar.value = amount
	$HarvestBar/HarvestButton.disabled = $HarvestBar.value < $HarvestBar.max_value
	return $HarvestBar.value == $HarvestBar.max_value


func _on_harvest_button_pressed():
	$HarvestBar.visible = false
	emit_signal("pressed_harvest")

func _on_bug_button_pressed():
	emit_signal("pressed_debug")

func _on_water_button_pressed():
	emit_signal("pressed_water")

func _on_plant_seed_pressed():
	SetPlanted(true)
	emit_signal("pressed_seed")
