class_name Ability
extends Resource

@export var name: String = "Ability Name"
@export_multiline var description: String = "Ability Description"
@export var damage: int = 0
@export var manaCost: int = 0
@export var damageType: DamageType = DamageType.PHYSICAL
@export var scene: PackedScene = null

enum DamageType {
	PHYSICAL,
	MAGICAL,
	TRUE
}