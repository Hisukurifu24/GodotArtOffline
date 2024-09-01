class_name QuestCollectObjective
extends QuestObjective

@export var target: Item
@export var amount: int = 1
var currentAmount: int = 0

func connect_signals():
	Quest_Manager.item_collected.connect(_on_item_collected)

func _on_item_collected(item):
	
	if item.name == target.name:
		# Increase the current amount (up to the amount required)
		currentAmount = min(amount, currentAmount + 1)
		# Emit signal
		objective_progressed.emit(self)

		# Check if the objective is completed
		if currentAmount >= amount:
			completed = true
		pass
	pass