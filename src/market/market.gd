extends StaticBody2D


func _ready():
	pass

func _process(_delta):
	pass

func _on_click_area_input_event(_viewport, event, _shape_idx):
	if !event.is_pressed():
		return
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		open_market_menu()

func open_market_menu():
	$AudioStreamPlayer2D.play()

func _on_range_area_area_entered(area):
	pass

func _on_range_area_area_exited(area):
	pass
