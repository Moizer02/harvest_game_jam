extends Node

##		Class Variables			################################################
@export var ScreenshotPath:String = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)


##		Built-in Functions		################################################
# Called when there is an input event
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("screenshot"):
		var milis = Time.get_unix_time_from_system()
		var d = Time.get_datetime_dict_from_unix_time(milis)
		var texture = get_viewport().get_texture()
		var image = texture.get_image()
		var fn = "GWJ62_%d-%s-%d_%02d%02d%02d.png" % [d.year,d.month,d.day,d.hour,d.minute,d.second]
		
		image.save_png(ScreenshotPath + fn)
	
	if event.is_action("zoom_in"):
		pass
		#_zoom(-1)
	elif event.is_action("zoom_out"):
		pass
		#_zoom(1)
	elif event is InputEventMouseButton and event.pressed:
		var colObj = null #cameraRay.get_collider()
		if colObj and colObj.has_method("Interact"):
			colObj.Interact(self)


##		Public Functions		################################################
##		Private Functions		################################################
