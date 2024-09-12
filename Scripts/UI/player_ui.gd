extends Draggable

var player: Character
var player_inventory: InventoryComponent

@onready var inventory_grid = %Equipment
@onready var profile_image = %ProfileImage
@onready var stats_ui = %Stats
@onready var close_button = %CloseButton

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player_inventory = player.get_node("Inventory")

	# Connect signals
	for slot: InventorySlotUI in inventory_grid.get_children():
		# slot.item_swapped.connect(_on_item_swapped)
		slot.item_used.connect(_on_item_used)

	player_inventory.inventory_changed.connect(update_inventory)

	close_button.connect("pressed", close)

	update_inventory()

func update_inventory():
	# Update profile image
	profile_image.texture = player.profile_image

	# Update stats
	update_stats()

	# Update inventory slots
	for i in range(player_inventory.inventorySize):
		var slot_ui: InventorySlotUI = inventory_grid.get_child(i)
		slot_ui.slot = player_inventory.get_slot(i)
		slot_ui.update()

func update_stats():
	stats_ui.get_node("HP/Value").text = str(player.maxStats.hp)
	stats_ui.get_node("MP/Value").text = str(player.maxStats.mp)
	stats_ui.get_node("AD/Value").text = str(player.maxStats.ad)
	stats_ui.get_node("AP/Value").text = str(player.maxStats.ap)
	stats_ui.get_node("ARM/Value").text = str(player.maxStats.armor)
	stats_ui.get_node("MR/Value").text = str(player.maxStats.mr)
	stats_ui.get_node("CRIT RATE/Value").text = str(player.maxStats.crit_pt) + "%"
	stats_ui.get_node("CRIT DMG/Value").text = str(player.maxStats.crit_dmg_pt) + "%"

func _input(event):
	if event.is_action_pressed("openPlayerInfo"):
		if visible:
			close()
		else:
			open()
	if event.is_action_pressed("ui_cancel"):
		close()

func _on_item_used(index: int):
	player_inventory.use_item(index)
	update_inventory()

func open():
	visible = true
	
	# Center the inventory on the screen
	global_position = get_viewport_rect().size / 2 - size / 2

	update_inventory()

func close():
	visible = false