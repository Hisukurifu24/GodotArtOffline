class_name InventorySlotUI
extends Control

signal item_swapped()
signal item_used(index: int)

@export var isEquipSlot: bool = false

var slot: Slot = null
var previewScene = preload("res://Scenes/item_drag_preview.tscn")

@onready var item_ui: TextureRect = %ItemIcon
@onready var quantity_ui: Label = %Quantity

func _get_drag_data(_at_position):
	if !slot:
		return null
	if !slot.item:
		return null

	# Create a preview of the item
	var preview = previewScene.instantiate()

	# Set preview texture
	var preview_texture = preview.get_node("TextureRect")
	preview_texture.texture = item_ui.texture
	preview_texture.size = item_ui.size / 1.5

	var preview_label = preview.get_node("TextureRect/Label")
	if slot.item is EquippableItem:
		preview_label.text = ""
	else:
		preview_label.text = str(slot.quantity)

	# Set the preview as the drag preview
	set_drag_preview(preview)

	var data = {
		"origin": self,
		"slot": slot,
	}

	# Clear the item icon
	item_ui.texture = null
	quantity_ui.text = ""

	# Return the preview texture
	return data

func _can_drop_data(_at_position, _data):
	# This may check if item is compatible with the slot (e.g. weapon slot only accepts weapons)
	if isEquipSlot:
		if _data["slot"].item is EquippableItem:
			return true
		else:
			return false
	else:
		return true

func _drop_data(_at_position, data):
	# Swap slots
	data["origin"].slot = slot
	slot = data["slot"]

	# Setup variables
	var origin = data["origin"].get_parent().name
	var originIndex = data["origin"].get_index()
	var target = self.get_parent().name
	var targetIndex = self.get_index()

	# Execute the swap
	swap_items(origin, originIndex, target, targetIndex)

# Restore the item icon if the drag failed
func _notification(what):
	if what == NOTIFICATION_DRAG_END and !get_viewport().gui_is_drag_successful():
		update()

func update():
	if slot and slot.item:
		item_ui.texture = slot.item.icon
		tooltip_text = slot.item.description
		if slot.item is EquippableItem:
			quantity_ui.text = ""
		else:
			quantity_ui.text = str(slot.quantity)
	else:
		item_ui.texture = null
		quantity_ui.text = ""
		tooltip_text = ""

func _gui_input(event: InputEvent) -> void:
	# Check for double click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
		if slot and slot.item:
			item_used.emit(get_index())


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

	# Emit signal
	item_swapped.emit()

func get_inventory_by_name(inv_name: String):
	match inv_name:
		"Equipment":
			return get_tree().get_first_node_in_group("Player").get_node("Inventory")
		"Bag":
			return get_tree().get_first_node_in_group("Player").get_node("Bag")
		_:
			printerr("Unknown inventory name: " + inv_name)
			return null
