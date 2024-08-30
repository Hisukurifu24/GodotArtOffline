class_name InventoryComponent
extends Node2D

signal item_collected(item: Item)

@export var player: Entity
@export var inventorySize: int = 6
@export var _items: Array[Item] = []

func _ready():
    _items.resize(inventorySize)

## Whether the inventory is active or passive (items increase player stats or not)
@export var isActiveInventory: bool = true

## Add an item to the inventory
func add_item(item: Item):
    if !isItemEquippable(item):
        return

    # Check if the item is stackable
    if item.maxStack > 1:
        # Check if the item is already in the inventory
        var index = _items.find(item)
        if index != -1:
            # Check if the item can be stacked
            if _items[index].quantity < item.maxStack:
                _items[index].quantity += 1
                _on_item_collected(item)
                return
        # If the item is not in the inventory, add it
        add_at_empty_slot(item)
        return
    else:
        add_at_empty_slot(item)

func add_at_empty_slot(item: Item):
    # Add the item to the inventory
    var index = _items.find(null)
    if index == -1:
        printerr("Inventory is full")
        return
    _items[index] = item
    _on_item_collected(item)

func insert_at(item: Item, index: int):
    if !isItemEquippable(item):
        return
    if index < 0 or index >= _items.size():
        printerr("Invalid index")
        return
    # print("Inserting" + item.name + "at index " + str(index))
    _items[index] = item
    _on_item_collected(item)

## Remove an item from the inventory
func remove_item(item: Item):
    # Remove the item from the inventory
    var index = _items.find(item)
    if index == -1:
        printerr("Item not found in inventory")
        return
    _on_item_removed(_items[index])
    _items[index] = null

func remove_at(index: int):
    if index < 0 or index >= _items.size():
        printerr("Invalid index")
        return
    # print("Removing item at index " + str(index))
    _on_item_removed(_items[index])
    _items[index] = null

## Get the item at the specified index
func get_item(index: int) -> Item:
    if index < 0 or index >= _items.size():
        return null
    return _items[index]

func _on_item_collected(item: Item):
    # Emit signal
    item_collected.emit(item)
    Quest_Manager.item_collected.emit(item) # Emit signal for quest system

    if isActiveInventory:
        # Increase the player's stats
        player.bonusStats.increase(item.stats)

func _on_item_removed(item: Item):
    if isActiveInventory:
        # Decrease the player's stats
        player.bonusStats.decrease(item.stats)

func print_inventory():
    print(name + ":")
    for i in range(_items.size()):
        print(_items[i])

func isItemEquippable(item: Item) -> bool:
    if isActiveInventory:
        # se l'oggetto non è equipaggiabile ritorna false
        if !(item is EquippableItem):
            printerr("Item is not equippable")
            return false
    return true