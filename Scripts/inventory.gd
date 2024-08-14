class_name InventoryComponent
extends Node2D

signal item_collected(item: Item)

@export var player: Entity
@export var items: Array[Item] = []

## Whether the inventory is active or passive (items increase player stats or not)
@export var isActiveInventory: bool = true

# Add an item to the inventory
func add_item(item: Item):
    # Add the item to the inventory
    items.append(item)
    
    item_collected.emit(item)
    Quest_Manager.item_collected.emit(item) # Emit signal for quest system

    if isActiveInventory:
        # Increase the player's stats
        player.bonusStats.increase(item.stats)

# Remove an item from the inventory
func remove_item(item: Item):
    # Remove the item from the inventory
    items.erase(items.find(item))
    
    if isActiveInventory:
        # Decrease the player's stats
        player.bonusStats.decrease(item.stats)
