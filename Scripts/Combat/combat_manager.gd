extends Node

var player: Character
var enemy: Enemy
@onready var combatGUI: CombatGUI = $"../Node2D/Combat_GUI"

var playerTurn: bool

func _ready():
	# For testing purposes
	player = get_tree().get_first_node_in_group("Player")
	player.abilities.insert(0, load("res://Resources/Abilities/attacco_base.tres"))
	player.abilities.insert(1, load("res://Resources/Abilities/attacco_base.tres"))
	player.abilities.insert(2, load("res://Resources/Abilities/attacco_base.tres"))
	player.abilities.insert(3, load("res://Resources/Abilities/attacco_base.tres"))

	enemy = get_tree().get_first_node_in_group("Enemy")
	# For testing purposes

	combatGUI.trying_to_run.connect(_on_run)
	combatGUI.used_ability.connect(_on_ability_used)

	playerTurn = true


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
		# Wait for the ability to finish
		await abilityNode.animationPlayer.animation_finished
		# Remove the ability node
		abilityNode.queue_free()

		# Deal damage to the enemy
		enemy.takeDamage(ability.damage)
		# Show the damage dealt
		combatGUI.showText("Player used " + ability.name + " dealing " + str(ability.damage) + " damage!")
		
		# Pass the turn to the enemy
		playerTurn = false
	else:
		# Show a message if the player doesn't have enough mana
		combatGUI.showText("Not enough mana!")
		await get_tree().create_timer(1.0).timeout
		# Show the combat options again
		combatGUI.showUI("combatOptions")
