extends CharacterBody2D


func _on_area_2d_body_entered(body:Node2D):
	if(body.name == "Character"):
		$DialogueBox.process_mode = Node.PROCESS_MODE_INHERIT
		$DialogueBox.show()


func _on_area_2d_body_exited(body:Node2D):
	if(body.name == "Character"):
		$DialogueBox.process_mode = Node.PROCESS_MODE_DISABLED
		$DialogueBox.hide()
