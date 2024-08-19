class_name InventorySlot
extends Control

signal item_swapped(origin: String, originIndex: int, target: String, targetIndex: int)

var item: Item = null
@onready var item_ui: TextureRect = %ItemIcon

func _ready():
	if item:
		item_ui.texture = item.icon

func _get_drag_data(_at_position):
	# Create a preview of the item
	var preview_texture = TextureRect.new()
	preview_texture.texture = item_ui.texture
	preview_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_texture.size = item_ui.size / 1.5
	
	# Create a container for the preview
	var preview = Control.new()
	preview.add_child(preview_texture)

	# Set the preview as the drag preview
	set_drag_preview(preview)

	var data = {
		"origin": self,
		"item": item,
		"texture": item_ui.texture
	}

	# Clear the item icon
	item_ui.texture = null

	# Return the preview texture
	return data

func _can_drop_data(_at_position, _data):
	# This may check if item is compatible with the slot (e.g. weapon slot only accepts weapons)
	return true

func _drop_data(_at_position, data):
	# Swap textures
	data["origin"].item_ui.texture = item_ui.texture
	item_ui.texture = data["texture"]

	# Swap items
	data["origin"].item = item
	item = data["item"]

	# Emit signal
	emit_signal("item_swapped", data["origin"].get_parent().name, data["origin"].get_index(), self.get_parent().name, self.get_index())

# Restore the item icon if the drag failed
func _notification(what):
	if what == NOTIFICATION_DRAG_END and !get_viewport().gui_is_drag_successful():
		# Drag failed, restore the item icon
		if item:
			item_ui.texture = item.icon
