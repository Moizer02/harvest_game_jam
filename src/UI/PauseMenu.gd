extends Control

var isPaused = false


func _ready():
	set_process_input(true)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		setPaused(!isPaused)

func setPaused(p : bool):
	get_tree().root.move_child(self, get_tree().root.get_child_count())
	isPaused = p
	visible = p
	get_tree().paused = p
	if p:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		pass
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_Resume_pressed():
	setPaused(false)

func _on_Save_pressed():
	pass # Replace with function body.

func _on_Options_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()
