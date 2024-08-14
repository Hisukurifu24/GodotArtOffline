class_name Reward
extends Resource

@export var experience: int = 200
@export var gold: int = 150
@export var item: Array[Item] = []

func give(player: Character):
	player.gainXP(experience)
	player.gold += gold
	# If the player has a BagComponent, add the items to it
	if player.get_node("Bag") is InventoryComponent:
		var bag: InventoryComponent = player.get_node("Bag")
		for i in item:
			bag.add_item(i)
	else:
		printerr("The player does not have a BagComponent")
	pass
