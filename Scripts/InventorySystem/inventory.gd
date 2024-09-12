class_name InventoryComponent
extends Node2D

signal item_collected(item: Item, quantity: int)
signal item_removed(item: Item, quantity: int)
signal inventory_changed()

@export var entity: Entity
@export var inventorySize: int = 6
var _items: Array[Slot] = []

func _ready():
	_items.resize(inventorySize)
	for i in _items.size():
		_items[i] = Slot.new()

	item_collected.connect(_on_item_collected)
	item_removed.connect(_on_item_removed)


## Whether the inventory is active or passive (items increase entity stats or not)
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
				item_collected.emit(item, quantity)
				return
			else:
				# Stack as much as possible
				quantity -= item.maxStack - _items[index].quantity
				_items[index].quantity = item.maxStack
				item_collected.emit(item, quantity)
				# Add the remaining quantity
				add_item(item, quantity)
				return
		else:
			# If the item is not in the inventory, add it
			_add_at_empty_slot(item, quantity)
			return
	else:
		# Add one to the inventory
		_add_at_empty_slot(item, 1)
		if quantity > 1:
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
		item_collected.emit(item, quantity)
	else:
		# Stack as much as possible
		_items[index].setSlot(item, item.maxStack)
		item_collected.emit(item, item.maxStack)
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
	item_collected.emit(item, quantity)

## Completely delete the first item that match from the inventory
func delete_item(item: Item):
	# Remove the item from the inventory
	var index = find(item)
	if index == -1:
		printerr("Item not found in inventory")
		return
	item_removed.emit(item, _items[index].quantity)
	_items[index].item = null

## Completely delete the item at the specified index
func delete_at(index: int):
	if index < 0 or index >= _items.size():
		printerr("Invalid index")
		return
	# print("Removing item at index " + str(index))
	item_removed.emit(_items[index].item, _items[index].quantity)
	_items[index].item = null

## Completely delete all items from the inventory
func delete_all():
	for i in range(_items.size()):
		delete_at(i)

func remove_at(index: int, amount: int = 1):
	if index < 0 or index >= _items.size():
		printerr("Invalid index")
		return
	if _items[index].item == null:
		printerr("No item at index " + str(index))
		return
	

	# Remove the specified amount of items
	# (automatically sets item to null if quantity beecome 0)
	_items[index].quantity -= clamp(amount, 0, _items[index].quantity)

	# Emit signal
	item_removed.emit(_items[index].item, _items[index].quantity)

## Get the item at the specified index
func get_slot(index: int) -> Slot:
	if index < 0 or index >= _items.size():
		return null
	return _items[index]

func _on_item_collected(item: Item, quantity: int):
	# Emit signal
	inventory_changed.emit()
	Quest_Manager.item_collected.emit(item, quantity) # Emit signal for quest system

	if isActiveInventory and item is EquippableItem:
		# Increase the entity's stats
		entity.bonusStats.increase(item.stats)

func _on_item_removed(item: Item, _quantity: int):
	# Emit signal
	inventory_changed.emit()

	if isActiveInventory and item is EquippableItem:
		# Decrease the entity's stats
		entity.bonusStats.decrease(item.stats)

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

func use_item(index: int):
	if index < 0 or index >= _items.size():
		printerr("Invalid index")
		return

	if _items[index].item is ConsumableItem:
		var item: ConsumableItem = _items[index].item
		if item.isBuff:
			# Increase the entity's stats (temporarily)
			entity.currentStats.increase(item.stats)
			await get_tree().create_timer(item.duration).timeout
			entity.currentStats.decrease(item.stats)
		else:
			# Increase the entity's stats (permanently)
			var time := 0
			var buffStats = Stats.divide_num(item.stats, item.duration)
			while time < item.duration:
				print("time " + str(time) + " - duration " + str(item.duration))
				print("ASPETTA!!!")
				entity.currentStats.increase(buffStats)
				if entity is Character:
					entity.energy += float(item.energy) / item.duration
					entity.water += float(item.water) / item.duration
				time += 1
				if item.duration > 1:
					await get_tree().create_timer(1).timeout
				else:
					# If item is instant, break the loop without waiting
					break
		# Item used, remove it from the inventory
		remove_at(index)
	elif _items[index].item is EquippableItem:
		var item: EquippableItem = _items[index].item
		if isActiveInventory:
			# Unequip the item
			var bag: InventoryComponent = entity.get_node("Bag")
			if bag.find(null) != -1:
				print("Unequipping item")
				bag.add_item(item)
				self.delete_at(index)
			else:
				printerr("Cannot unequip cause bag is full")
		else:
			# Equip the item
			var inventory: InventoryComponent = entity.get_node("Inventory")
			if inventory.find(null) != -1:
				print("Equipping item")
				inventory.add_item(item)
				self.delete_at(index)
			else:
				printerr("Cannot equip inventory bag is full")
	else:
		printerr("Item cannot be used")
