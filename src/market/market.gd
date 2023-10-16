extends StaticBody2D

var in_range: bool = false

func _ready():
	pass

func _process(delta):
	pass

func _on_click_area_input_event(viewport, event, shape_idx):
	if !event.is_pressed():
		return
	if !in_range:
		return
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		open_market_menu()
		print(in_range)

func open_market_menu():
	$AudioStreamPlayer2D.play()

func _on_range_area_area_entered(area):
	in_range = true

func _on_range_area_area_exited(area):
	in_range = false
