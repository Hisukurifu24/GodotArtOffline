extends Control


var player: Character
var player_inventory: InventoryComponent
var player_bag: InventoryComponent

@onready var inventory_slots = %Inventory
@onready var bag_slots = %Bag

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player_inventory = player.get_node("Inventory")
	player_bag = player.get_node("Bag")

	for slot: InventorySlot in inventory_slots.get_children():
		slot.item_swapped.connect(swap_items)
	for slot: InventorySlot in bag_slots.get_children():
		slot.item_swapped.connect(swap_items)
	
	update_inventory()

func _input(event):
	if event.is_action_pressed("openInventory"):
		visible = not visible
		update_inventory()
	if event.is_action_pressed("ui_cancel"):
		visible = false
	
func update_inventory():
	for i in range(player_bag.inventorySize):
		var slot: InventorySlot = bag_slots.get_child(i)
		slot.item = player_bag.get_item(i)
		if slot.item != null:
			slot.item_ui.texture = slot.item.icon
		else:
			slot.item_ui.texture = null
	for i in range(player_inventory.inventorySize):
		var slot: InventorySlot = inventory_slots.get_child(i)
		slot.item = player_inventory.get_item(i)
		if slot.item != null:
			slot.item_ui.texture = slot.item.icon
		else:
			slot.item_ui.texture = null

func swap_items(origin: String, originIndex: int, target: String, targetIndex: int):
	# print("Swapping item: " + origin + "[" + str(originIndex) + "] with " + target + "[" + str(targetIndex) + "]")

	# Retrieve the origin and target inventories
	var origin_inventory: InventoryComponent = get_inventory_by_name(origin)
	var target_inventory: InventoryComponent = get_inventory_by_name(target)

	# Retrieve the items to swap
	var origin_item: Item = origin_inventory.get_item(originIndex)
	var target_item: Item = target_inventory.get_item(targetIndex)

	if origin_item == null and target_item == null:
		print("No items to swap")
	elif origin_item == null:
		print("origin_item is null")
		origin_inventory.insert_at(target_item, originIndex)
		target_inventory.remove_at(targetIndex)
	elif target_item == null:
		print("target_item is null")
		target_inventory.insert_at(origin_item, targetIndex)
		origin_inventory.remove_at(originIndex)
	else:
		# Swap the items
		origin_inventory.insert_at(target_item, originIndex)
		target_inventory.insert_at(origin_item, targetIndex)

	# print("--------------------------------")
	# player_inventory.print_inventory()
	# player_bag.print_inventory()

	update_inventory()

func get_inventory_by_name(inv_name: String):
	match inv_name:
		"Inventory":
			return player_inventory
		"Bag":
			return player_bag
		_:
			printerr("Unknown inventory name: " + inv_name)
			return null
