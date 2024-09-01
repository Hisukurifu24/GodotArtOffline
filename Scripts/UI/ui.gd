extends CanvasLayer

@onready var hpBar = $"Control/HP"
@onready var manaBar = $"Control/Mana"
@onready var energyBar = $"Control/Energia"
@onready var waterBar = $"Control/Sete"
@onready var expBar = $"Control/Exp"
@onready var staminaBar = $"Control/Stamina"
@onready var staminaTimer = $"StaminaHideTimer"
@onready var goldLabel = %GoldText

@onready var questFollow_ui = %QuestFollow
@onready var quest_ui = %Quest

var player: Character

func _ready():
	player = get_tree().get_first_node_in_group("Player")

	player.player_stats_changed.connect(_on_character_stats_changed)

	player.xp_changed.connect(_on_character_xp_changed)
	player.stamina_changed.connect(_on_character_stamina_changed)
	player.energy_changed.connect(_on_character_energy_changed)
	player.water_changed.connect(_on_character_water_changed)
	player.gold_changed.connect(_on_character_gold_changed)

func _on_character_stats_changed():
	_on_character_health_changed(player.currentStats.hp, player.maxStats.hp)
	_on_character_mana_changed(player.currentStats.mp, player.maxStats.mp)

func _on_character_health_changed(hp, max_hp):
	hpBar.max_value = max_hp
	hpBar.value = hp
	hpBar.get_node("Label").text = str(hp) + "/" + str(max_hp)

func _on_character_mana_changed(mana, max_mana):
	manaBar.max_value = max_mana
	manaBar.value = mana
	manaBar.get_node("Label").text = str(mana) + "/" + str(max_mana)

func _on_character_energy_changed(energy, max_energy):
	energyBar.max_value = max_energy
	energyBar.value = energy

func _on_character_water_changed(water, max_water):
	waterBar.max_value = max_water
	waterBar.value = water

func _on_character_xp_changed(xp, max_xp, lvl):
	expBar.max_value = max_xp
	expBar.value = xp
	expBar.get_node("Level").text = "lvl: " + str(lvl)

func _on_character_gold_changed(gold):
	goldLabel.text = "Gold: " + str(gold)

func _on_character_stamina_changed(stamina):
	if stamina < 25:
		staminaBar.modulate = Color("999999")
	else:
		staminaBar.modulate = Color("ffffff")
	if stamina > 99:
		staminaTimer.start()
	else:
		staminaBar.visible = true
	staminaBar.value = stamina

func _on_stamina_hide_timer_timeout():
	staminaBar.visible = false

func updateQuests():
	questFollow_ui.visible = false

	var followQuest = Quest_Manager.followQuest

	# If there is no follow quest, return
	if !followQuest:
		return
	
	# Show the follow quest
	questFollow_ui.visible = true

	var title_ui = quest_ui.get_node("Title")
	var completedCount = 0

	# For each objective (max 3), show it in the UI
	for j in range(3):
		# Get the objective UI
		var objective_ui = quest_ui.get_node("Objective" + str(j + 1))

		# Check if the objective exists
		if j < followQuest.questInfo.objectives.size():
			# Show the objective
			objective_ui.visible = true
			# Set the objective text
			objective_ui.text = "- " + followQuest.questInfo.objectives[j].text
			# Add the current amount and the total amount
			objective_ui.text += " (" + str(followQuest.questInfo.objectives[j].currentAmount) + "/" + str(followQuest.questInfo.objectives[j].amount) + ")"
			
			# Check if the objective is completed
			if followQuest.questInfo.objectives[j].completed:
				# Mark the objective as completed
				objective_ui.modulate = Color("00dd00")

				# Increment the completed count
				completedCount += 1
			else:
				# Mark the objective as not completed
				objective_ui.modulate = Color("ffffff")
		else:
			# Hide the objective
			objective_ui.visible = false
	
	# Check if the quest is wholly completed
	if completedCount == followQuest.questInfo.objectives.size():
		# Mark the quest as ready to deliver
		# title_ui.modulate = Color("00ff00")
		title_ui.text = followQuest.questInfo.name + "\n(Complete)"
	else:
		# title_ui.modulate = Color("ffffff")
		title_ui.text = followQuest.questInfo.name
