class_name InventoryUI
extends Draggable

var player: Character
var player_inventory: InventoryComponent
var player_bag: InventoryComponent

@onready var bag_grid = %Bag
@onready var page_label = %Page
@onready var prev_button = %PrevButton
@onready var next_button = %NextButton

var current_page: int = 1:
	set(value):
		current_page = clamp(value, 1, max_pages)
var slots_per_page: int = 28:
	get:
		return bag_grid.get_child_count()
var max_pages: int = 5:
	get:
		return ceili(float(player_bag.inventorySize) / slots_per_page)

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if player:
		player_inventory = player.get_node("Inventory")
		player_bag = player.get_node("Bag")
	else:
		push_error("Player not found in scene")

	# Connect signals
	for slot: InventorySlotUI in bag_grid.get_children():
		slot.item_swapped.connect(_on_item_swapped)
		slot.item_used.connect(_on_item_used)
	
	player_bag.inventory_changed.connect(update_inventory)

	prev_button.connect("pressed", _on_PrevButton_pressed)
	next_button.connect("pressed", _on_NextButton_pressed)

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
	# Update page label
	page_label.text = str(current_page) + "/" + str(max_pages)

	# Disable buttons if necessary
	prev_button.disabled = true if current_page == 1 else false
	next_button.disabled = true if current_page == max_pages else false

	# Update inventory slots
	# cycle through the slots in the current page
	for i in range((current_page - 1) * slots_per_page, (current_page) * slots_per_page):
		# i = current index in the inventory (based on the current page)
		var slot_ui: InventorySlotUI = bag_grid.get_child(i - (current_page - 1) * slots_per_page)
		slot_ui.slot = player_bag.get_slot(i)
		slot_ui.update()
	# for i in range(player_inventory.inventorySize):
	# 	var slot_ui: InventorySlotUI = inventory_slots.get_child(i)
	# 	slot_ui.slot = player_inventory.get_slot(i)
	# 	slot_ui.update()

func _on_item_swapped(origin: String, originIndex: int, target: String, targetIndex: int):
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

func _on_PrevButton_pressed():
	current_page -= 1
	update_inventory()

func _on_NextButton_pressed():
	current_page += 1
	update_inventory()

func _on_item_used(slot: int):
	player_bag.use_item(slot)
	update_inventory()