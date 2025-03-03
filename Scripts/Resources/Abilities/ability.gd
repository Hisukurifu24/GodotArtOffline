class_name Ability
extends Resource

@export var name: String = "Ability Name"
@export_multiline var description: String = "Ability Description"
@export var baseValue: int = 0
@export_range(0, 1) var scalingValue: float = 0.0
@export var scalingStat: Stats.StatType = Stats.StatType.AD
@export var manaCost: int = 0
@export var scene: PackedScene = null
