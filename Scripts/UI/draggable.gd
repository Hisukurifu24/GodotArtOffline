class_name Draggable
extends Control

var safe_zone: int = 50

var dragging := false
var drag_offset: Vector2
@onready var screen_size: Vector2 = get_window().size

func _process(_delta):
	if dragging:
		set_pos(get_viewport().get_mouse_position() - drag_offset)

func set_pos(pos: Vector2):

	pos.x = clamp(pos.x, -size.x + safe_zone, screen_size.x - safe_zone)
	pos.y = clamp(pos.y, -size.y + safe_zone, screen_size.y - safe_zone)
	global_position = pos

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed() and !dragging:
				dragging = true
				drag_offset = get_global_mouse_position() - global_position
			elif event.is_released() and dragging:
				dragging = false
