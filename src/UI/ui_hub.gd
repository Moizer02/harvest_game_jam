extends CanvasLayer

# This maybe functions as an API for other scripts to access the UI Elements

var ui_elements = {}

func _ready():
	# Adds all UI Elements into the dict for easy access
	for i in get_children(false):
		i.visible = false
		ui_elements[i.name] = i

func _process(delta):
	pass

#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		$MarketUI.visible = !$MarketUI.visible
