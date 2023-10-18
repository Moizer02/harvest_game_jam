extends StaticBody2D

@export var marketui: ColorRect

func _ready():
	pass

func _process(_delta):
	pass


func _on_click_area_body_entered(body):
	if body.name == "Player":
		marketui.visible = true
		$AudioStreamPlayer2D.play()

func _on_click_area_body_exited(body):
	if body.name == "Player":
		marketui.visible = false
