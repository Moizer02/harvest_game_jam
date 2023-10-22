extends Panel

var debounce:bool = false


func _onOpenPressed():
	$Cutscene.play("cutscene")
	await $Cutscene.animation_finished
	get_tree().reload_current_scene()
