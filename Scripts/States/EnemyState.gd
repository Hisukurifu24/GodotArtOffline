class_name EnemyState
extends State

@export var enemy: Enemy

var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")