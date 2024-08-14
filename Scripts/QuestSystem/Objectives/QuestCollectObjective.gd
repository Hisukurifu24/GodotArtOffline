class_name QuestCollectObjective
extends QuestObjective

@export var target: Item
@export var amount: int = 1

func connect_signals():
	Quest_Manager.item_collected.connect(_on_item_collected)

func _on_item_collected(item):
	
	if item.name == target.name:
		amount -= 1
		if amount <= 0:
			completed = true
		pass
	pass