class_name InventorySlot
extends Control

var item: Item = null
@onready var item_ui: TextureRect = $"Background/Item Icon"

func _ready():
	if item:
		item_ui.texture = item.icon

func _get_drag_data(_at_position):
	print("Dragged item")

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
	print("Dropped data: ", data)

	# Swap textures
	data["origin"].item_ui.texture = item_ui.texture
	item_ui.texture = data["texture"]

	# Swap items
	data["origin"].item = item
	item = data["item"]
