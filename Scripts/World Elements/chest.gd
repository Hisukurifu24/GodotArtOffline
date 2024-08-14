extends Node2D

var opened := false

## Ricompensa casuale
@export var randomLoot = true

## Ricompensa, se randomLoot è false
@export var loot: Reward

@onready var sprite = $AnimatedSprite2D
@onready var area = $Area2D

func _ready():
	if randomLoot:
		# loot = Reward.random()
		pass
	area.connect("body_entered", _on_Area2D_body_entered)

func _on_Area2D_body_entered(body):
	if body is Character and !opened:
		opened = true
		sprite.play("open")
		loot.give(body)
