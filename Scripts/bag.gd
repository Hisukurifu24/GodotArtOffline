class_name BagComponent
extends Node2D

@export var player: Entity
@export var items: Array[Item] = []

# Add an item to the inventory
func add_item(item: Item):
    # Add the item to the inventory
    items.append(item)

# Remove an item from the inventory
func remove_item(item: Item):
    # Remove the item from the inventory
    items.erase(items.find(item))
