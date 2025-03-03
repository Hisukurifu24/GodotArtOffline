extends Node

var player: Character
var enemy: Enemy
@onready var combatGUI: CombatGUI = get_tree().get_first_node_in_group("CombatGUI")

var combatAI: CombatAI

var playerTurn: bool

func _ready():
	# For testing purposes
	player = get_tree().get_first_node_in_group("Player")
	player.abilities.insert(0, load("res://Resources/Abilities/attacco_base.tres"))
	player.abilities.insert(1, load("res://Resources/Abilities/attacco_base.tres"))
	player.abilities.insert(2, load("res://Resources/Abilities/attacco_base.tres"))
	player.abilities.insert(3, load("res://Resources/Abilities/attacco_base.tres"))

	enemy = get_tree().get_first_node_in_group("Enemy")
	print("befbef Enemy HP: ", enemy.currentStats.hp)
	# For testing purposes

	combatGUI.trying_to_run.connect(_on_run)
	combatGUI.used_ability.connect(_on_ability_used)

	# Instantiate the combat AI
	combatAI = CombatAI.new(player, enemy)

	# Check who goes first
	playerTurn = player.speed > enemy.speed

func _process(_delta):
	if (!playerTurn):
		# Check if the enemy is dead
		if enemy.currentStats.hp <= 0:
			combatGUI.showText("You won!")
			await get_tree().create_timer(2.0).timeout
			get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
		else:
			# Enemy's turn
			var ability_index: int = combatAI.chooseAbility()
			var ability: Ability = enemy.abilities[ability_index]


func _on_run():
	# Check if the player can run away
	if player.speed > enemy.speed:
		combatGUI.showText("Scampato pericolo!")
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
	else:
		combatGUI.showText("Non sei riuscito a scappare!")
		await get_tree().create_timer(2.0).timeout
		# Pass the turn to the enemy
		playerTurn = false

func _on_ability_used(ability_index: int):
	# Get the ability from the player
	var ability: Ability = player.abilities[ability_index]

	# Check if the player has enough mana to use the ability
	if player.currentStats.mp >= ability.manaCost:
		player.currentStats.mp -= ability.manaCost

		# Instantiate the ability scene
		var abilityNode: AbilityNode = ability.scene.instantiate()
		get_node("../Combat Scene").add_child(abilityNode)
		# Wait for the ability to finish
		await abilityNode.abilityFinished
		# Remove the ability node
		abilityNode.queue_free()

		# Calculate damage
		var damage := _calculate_damage(ability, player, enemy)

		print("bef Enemy HP: ", enemy.currentStats.hp)
		# Deal damage to the enemy
		enemy.takeDamage(damage)
		print("Enemy HP: ", enemy.currentStats.hp)
		# Show the damage dealt
		combatGUI.showText("Player used " + ability.name + " dealing " + str(damage) + " damage!")
		await get_tree().create_timer(2.0).timeout
		# Pass the turn to the enemy
		playerTurn = false
	else:
		# Show a message if the player doesn't have enough mana
		combatGUI.showText("Not enough mana!")
		await get_tree().create_timer(1.0).timeout
		# Show the combat options again
		combatGUI.showUI("combatOptions")

func _calculate_damage(ability: AttackAbility, caster: Entity, target: Entity) -> float:
	if ability.is_class("HealingAbility"):
		printerr("Tried to calculate damage for a healing ability!")
		return 0
	var damage: float = ability.baseValue;
	damage += ability.scalingValue * caster.currentStats.getStatbyType(ability.scalingStat)
	if ability.damageType == AttackAbility.DamageType.PHYSICAL:
		damage -= target.currentStats.armor
	elif ability.damageType == AttackAbility.DamageType.MAGICAL:
		damage -= target.currentStats.mr
	return max(damage, 0)