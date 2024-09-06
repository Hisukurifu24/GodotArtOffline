extends Draggable

var player: Character
var player_inventory: InventoryComponent
var player_bag: InventoryComponent

@onready var inventory_slots = %Inventory
@onready var bag_slots = %Bag

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if player:
		player_inventory = player.get_node("Inventory")
		player_bag = player.get_node("Bag")
	else:
		push_error("Player not found in scene")

	for slot: InventorySlotUI in inventory_slots.get_children():
		slot.item_swapped.connect(swap_items)
	for slot: InventorySlotUI in bag_slots.get_children():
		slot.item_swapped.connect(swap_items)
	
	update_inventory()

func _input(event):
	if event.is_action_pressed("openInventory"):
		if visible:
			close()
		else:
			open()
	if event.is_action_pressed("ui_cancel"):
		close()
	
func update_inventory():
	for i in range(player_bag.inventorySize):
		var slot_ui: InventorySlotUI = bag_slots.get_child(i)
		slot_ui.slot = player_bag.get_slot(i)
		slot_ui.update()
	for i in range(player_inventory.inventorySize):
		var slot_ui: InventorySlotUI = inventory_slots.get_child(i)
		slot_ui.slot = player_inventory.get_slot(i)
		slot_ui.update()

func swap_items(origin: String, originIndex: int, target: String, targetIndex: int):
	# print("Swapping item: " + origin + "[" + str(originIndex) + "] with " + target + "[" + str(targetIndex) + "]")

	# Retrieve the origin and target inventories
	var origin_inventory: InventoryComponent = get_inventory_by_name(origin)
	var target_inventory: InventoryComponent = get_inventory_by_name(target)

	# Retrieve the slots to swap
	var origin_slot: Slot = origin_inventory.get_slot(originIndex)
	var target_slot: Slot = target_inventory.get_slot(targetIndex)

	if origin_slot.item == null and target_slot.item == null:
		printerr("No items to swap")
	elif origin_slot.item == null:
		printerr("Cannot swap an empty item")
	elif target_slot.item == null:
		# It means item was moved to an empty slot
		# So insert at target index and remove from origin index
		target_inventory.insert_at(targetIndex, origin_slot.item, origin_slot.quantity)
		origin_inventory.delete_at(originIndex)
	else:
		# If the items are different 
		if origin_slot.item.name != target_slot.item.name:
			# Swap the items
			var temp_slot = Slot.new(origin_slot.item, origin_slot.quantity)
			origin_inventory.insert_at(originIndex, target_slot.item, target_slot.quantity)
			target_inventory.insert_at(targetIndex, temp_slot.item, temp_slot.quantity)
		else:
			# The items are the same
			# If the item is stackable
			if origin_slot.item.maxStack > 1:
				# If space is enough to stack them
				if origin_slot.quantity + target_slot.quantity <= origin_slot.item.maxStack:
					# Stack at target index and remove from origin index
					target_inventory.insert_at(targetIndex, origin_slot.item, origin_slot.quantity + target_slot.quantity)
					origin_inventory.delete_at(originIndex)
				else:
					# Stack as much as possible at target index
					origin_slot.quantity -= origin_slot.item.maxStack - target_slot.quantity
					target_slot.quantity = target_slot.item.maxStack
			else:
				# If the item is not stackable, swap them
				origin_inventory.insert_at(originIndex, target_slot.item, target_slot.quantity)
				target_inventory.insert_at(targetIndex, origin_slot.item, origin_slot.quantity)

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

func open():
	visible = true
	
	# Center the inventory on the screen
	global_position = get_viewport_rect().size / 2 - size / 2

	update_inventory()

func close():
	visible = false
