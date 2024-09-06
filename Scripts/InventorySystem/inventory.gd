class_name InventoryComponent
extends Node2D

signal item_collected(item: Item)

@export var player: Entity
@export var inventorySize: int = 6
var _items: Array[Slot] = []

func _ready():
	_items.resize(inventorySize)
	print(inventorySize)
	for i in _items.size():
		_items[i] = Slot.new()


## Whether the inventory is active or passive (items increase player stats or not)
@export var isActiveInventory: bool = true

## Add an item to the inventory
func add_item(item: Item, quantity: int = 1):
	if !isItemEquippable(item):
		return

	# Check if the item is stackable
	if item.maxStack > 1:
		# Check if the item is already in the inventory
		var index = find(item)
		if index != -1:
			# Check if the item can be fully stacked
			if _items[index].quantity + quantity <= item.maxStack:
				_items[index].quantity += quantity
				_on_item_collected(item)
				return
			else:
				# Stack as much as possible
				quantity -= item.maxStack - _items[index].quantity
				_items[index].quantity = item.maxStack
				# Add the remaining quantity
				add_item(item, quantity)
				return
		else:
			# If the item is not in the inventory, add it
			_add_at_empty_slot(item, quantity)
			return
	else:
		if quantity > 1:
			# Add one to the inventory
			_add_at_empty_slot(item, 1)
			# Add the remaining quantity
			add_item(item, quantity - 1)
			return

func _add_at_empty_slot(item: Item, quantity: int):
	# Add the item to the inventory
	var index = find(null)
	if index == -1:
		printerr("Inventory is full")
		return

	# Check if the item can be fully stacked
	if quantity <= item.maxStack:
		_items[index] = Slot.new(item, quantity)
		_on_item_collected(item)
	else:
		# Stack as much as possible
		_items[index].setSlot(item, item.maxStack)
		# Add the remaining quantity
		_add_at_empty_slot(item, quantity - item.maxStack)
		return

func insert_at(index: int, item: Item, quantity: int = 1):
	if !isItemEquippable(item):
		return

	# Check for index validity
	if index < 0 or index >= _items.size():
		printerr("Invalid index")
		return
	
	if quantity > item.maxStack:
		printerr("Quantity exceeds max stack")
		return
	
	# Overwrite the item at the specified index
	_items[index].setSlot(item, quantity)
	_on_item_collected(item)

## Remove the first item that match from the inventory
func delete_item(item: Item):
	# Remove the item from the inventory
	var index = find(item)
	if index == -1:
		printerr("Item not found in inventory")
		return
	_on_item_removed(item)
	_items[index].item = null

## Remove the item at the specified index
func delete_at(index: int):
	if index < 0 or index >= _items.size():
		printerr("Invalid index")
		return
	# print("Removing item at index " + str(index))
	_on_item_removed(_items[index].item)
	_items[index].item = null

## Get the item at the specified index
func get_slot(index: int) -> Slot:
	if index < 0 or index >= _items.size():
		return null
	return _items[index]

func _on_item_collected(item: Item):
	# Emit signal
	item_collected.emit(item)
	Quest_Manager.item_collected.emit(item) # Emit signal for quest system

	if isActiveInventory and item is EquippableItem:
		# Increase the player's stats
		player.bonusStats.increase(item.stats)

func _on_item_removed(item: Item):
	if isActiveInventory and item is EquippableItem:
		# Decrease the player's stats
		player.bonusStats.decrease(item.stats)

func print_inventory():
	print(name + ":")
	for slot in _items:
		print(slot.item)

## Check if an non-equippable item is trying to be added to the inventory.
## Returns false if the item is not equippable else true
func isItemEquippable(item: Item) -> bool:
	if isActiveInventory:
		# se l'oggetto non è equipaggiabile ritorna false
		if !(item is EquippableItem):
			printerr("Item is not equippable")
			return false
	return true

func find(item: Item) -> int:
	for i in range(_items.size()):
		if _items[i].item == item:
			return i
	return -1