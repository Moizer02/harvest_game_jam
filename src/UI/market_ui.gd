extends Panel

var debounce:bool = false
var harvested = 0


func UpdateStock(item:String, value):
	harvested = value
	$Canopy/Stock.text = value


func _onOpenPressed():
	if debounce: return
	debounce = true
	$Cutscene.play("cutscene")
	await $Cutscene.animation_finished
	# @TODO: add text to the end that congratulates the player for winning/losing
	get_tree().reload_current_scene()

func _on_credits_pressed():
	pass # Replace with function body.
