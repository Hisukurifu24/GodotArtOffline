class_name Reward
extends Node

@export var experience: int = 200
@export var gold: int = 150
#@export var item: Item = []	Da fare

var player: Character

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	pass

func receive():
	player.experience += experience
	player.gold += gold
	queue_free()
	pass