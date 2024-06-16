extends Area2D


func _on_body_entered(body:Node2D):
	if body.name == "Character":
		$AnimatedSprite2D.play("open")
		$StaticBody2D.process_mode = PROCESS_MODE_DISABLED


func _on_body_exited(body:Node2D):
	if body.name == "Character":
		$AnimatedSprite2D.play("closed")
		$StaticBody2D.process_mode = PROCESS_MODE_INHERIT
