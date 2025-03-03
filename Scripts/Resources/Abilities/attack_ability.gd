class_name AttackAbility
extends Ability

@export var damageType: DamageType = DamageType.PHYSICAL

enum DamageType {
	PHYSICAL,
	MAGICAL,
	TRUE
}