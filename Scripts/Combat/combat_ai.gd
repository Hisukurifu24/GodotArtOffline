class_name CombatAI

var player: Character
var enemy: Enemy

func _init(_player: Character, _enemy: Enemy) -> void:
	player = _player
	enemy = _enemy

func chooseAbility() -> int:
	var ability_index: int = -1
	if enemy.currentStats.hp < enemy.maxStats.hp / 4:
		# If the enemy has less than 25% of its health, use some healing ability if available
		ability_index = _search_healing_ability()
		if ability_index != -1:
			return ability_index
		# Otherwise, see next conditions
	# If the enemy has way more ad than ap, use an ad ability,
	if enemy.currentStats.ad >= enemy.currentStats.ap * 2:
		ability_index = _search_ad_scaling_ability()
		if ability_index != -1:
			return ability_index
		# Otherwise, see next conditions
	# otherwise use an ap ability, 
	if enemy.currentStats.ap >= enemy.currentStats.ad * 2:
		ability_index = _search_ap_scaling_ability()
		if ability_index != -1:
			return ability_index
		# Otherwise, see next conditions
	# otherwise look for player's weaknesses
	if player.currentStats.armor <= player.currentStats.mr:
		# If the player has less armor than magic resist, use an ad ability
		ability_index = _search_ad_ability()
		if ability_index != -1:
			return ability_index
		# Otherwise, see next conditions
	else:
		# Otherwise use an ap ability
		ability_index = _search_ap_ability()
		if ability_index != -1:
			return ability_index
		# Otherwise, see next conditions

	# If no ability was found, use base attack
	return 0

func _search_healing_ability() -> int:
	for i in range(enemy.abilities.size()):
		if enemy.abilities[i].is_class("HealingAbility"):
			return i
	return -1

func _search_ad_scaling_ability() -> int:
	for i in range(enemy.abilities.size()):
		if enemy.abilities[i].scalingType == Stats.StatType.AD:
			return i
	return -1
func _search_ap_scaling_ability() -> int:
	for i in range(enemy.abilities.size()):
		if enemy.abilities[i].scalingType == Stats.StatType.AP:
			return i
	return -1
func _search_ad_ability() -> int:
	for i in range(enemy.abilities.size()):
		if enemy.abilities[i].is_class("AttackAbility") && enemy.abilities[i].damageType == AttackAbility.DamageType.PHYSICAL:
			return i
	return -1
func _search_ap_ability() -> int:
	for i in range(enemy.abilities.size()):
		if enemy.abilities[i].is_class("AttackAbility") && enemy.abilities[i].damageType == AttackAbility.DamageType.MAGICAL:
			return i
	return -1
