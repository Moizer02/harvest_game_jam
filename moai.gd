extends Sprite2D


func _ready():
	pass

func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	$AudioStreamPlayer2D.play()
	OS.shell_open("https://steamcommunity.com/id/oSPumb4/")
