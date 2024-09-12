class_name InventorySlotUI
extends Control

signal item_swapped(origin: String, originIndex: int, target: String, targetIndex: int)
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

	# Emit signal
	item_swapped.emit(origin, originIndex, target, targetIndex)

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
