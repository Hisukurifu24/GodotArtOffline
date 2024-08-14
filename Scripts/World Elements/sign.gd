extends StaticBody2D

@export_multiline var text = ""
var inside = false

func _ready():
	$"Panel/Label".text = text

func _input(event):
	if event.is_action_pressed("ui_accept") and inside:
		$Panel.visible = true

func _on_area_2d_body_entered(body:Node2D):
	if body.name == "Character":
		inside = true

func _on_area_2d_body_exited(body:Node2D):
	if body.name == "Character":
		inside = false
		$Panel.visible = false
