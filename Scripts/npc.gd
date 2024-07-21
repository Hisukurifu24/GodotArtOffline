extends CharacterBody2D

var interactable := false

func _input(event):
	if event.is_action_pressed("ui_accept") and interactable:
		# Show the dialogue box
		$DialogueBox.process_mode = Node.PROCESS_MODE_INHERIT
		$DialogueBox.show()
		$DialogueBox.updateDialog()

func _on_area_2d_body_entered(body: Node2D):
	if (body.name == "Character"):
		interactable = true

func _on_area_2d_body_exited(body: Node2D):
	if (body.name == "Character"):
		interactable = false

		# Hide the dialogue box
		$DialogueBox.process_mode = Node.PROCESS_MODE_DISABLED
		$DialogueBox.hide()

		# Reset the dialogue box
		$DialogueBox.currentIndex = 0
		$DialogueBox.updateDialog()
