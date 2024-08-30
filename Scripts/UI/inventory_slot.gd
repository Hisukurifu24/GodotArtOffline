class_name InventorySlot
extends Control

signal item_swapped(origin: String, originIndex: int, target: String, targetIndex: int)

@export var isEquipSlot: bool = false

var item: Item = null
var previewScene = preload("res://Scenes/item_drag_preview.tscn")

@onready var item_ui: TextureRect = %ItemIcon
@onready var quantity_ui: Label = %Quantity


# func _ready():
# 	if item:
# 		item_ui.texture = item.icon
# 		quantity_ui.text = str(item.quantity)

func _get_drag_data(_at_position):
	if !item:
		return null

	# Create a preview of the item
	var preview = previewScene.instantiate()

	# Set preview texture
	var preview_texture = preview.get_node("TextureRect")
	preview_texture.texture = item_ui.texture
	preview_texture.size = item_ui.size / 1.5

	var preview_label = preview.get_node("TextureRect/Label")
	preview_label.text = str(item.quantity)

	# Set the preview as the drag preview
	set_drag_preview(preview)

	var data = {
		"origin": self,
		"item": item,
		# "texture": item_ui.texture
	}

	# Clear the item icon
	item_ui.texture = null
	quantity_ui.text = ""

	# Return the preview texture
	return data

func _can_drop_data(_at_position, _data):
	# This may check if item is compatible with the slot (e.g. weapon slot only accepts weapons)
	if isEquipSlot:
		if _data["item"] is EquippableItem:
			return true
		else:
			return false
	else:
		return true

func _drop_data(_at_position, data):
	# Swap textures
	# data["origin"].item_ui.texture = item_ui.texture
	# item_ui.texture = data["texture"]

	# Swap items
	data["origin"].item = item
	item = data["item"]

	# Update slots data
	data["origin"].update()
	self.update()

	# Emit signal
	emit_signal("item_swapped", data["origin"].get_parent().name, data["origin"].get_index(), self.get_parent().name, self.get_index())

# Restore the item icon if the drag failed
func _notification(what):
	if what == NOTIFICATION_DRAG_END and !get_viewport().gui_is_drag_successful():
		update()

func update():
	if item:
		item_ui.texture = item.icon
		quantity_ui.text = str(item.quantity)
	else:
		item_ui.texture = null
		quantity_ui.text = ""
