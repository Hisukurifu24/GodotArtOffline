class_name HealAbility
extends Ability

@export var healType: HealType = HealType.HEAL

enum HealType {
	HEAL,
	SHIELD
}