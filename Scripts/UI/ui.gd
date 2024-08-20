extends CanvasLayer

@onready var hpBar = $"Control/HP"
@onready var manaBar = $"Control/Mana"
@onready var energyBar = $"Control/Energia"
@onready var waterBar = $"Control/Sete"
@onready var expBar = $"Control/Exp"
@onready var staminaBar = $"Control/Stamina"
@onready var staminaTimer = $"StaminaHideTimer"
@onready var goldLabel = $"Control/Gold"

@onready var quest1 = $"Control/Control/Quests/Quest1"
@onready var quest2 = $"Control/Control/Quests/Quest2"
@onready var quest3 = $"Control/Control/Quests/Quest3"

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
		staminaBar.get("theme_override_styles/fill").bg_color = Color("adad00")
	else:
		staminaBar.get("theme_override_styles/fill").bg_color = Color("ffff77")
	if stamina > 99:
		staminaTimer.start()
	else:
		staminaBar.visible = true
	staminaBar.value = stamina

func _on_stamina_hide_timer_timeout():
	staminaBar.visible = false

func updateQuests(acceptedQuests: Array[Quest]):
	quest1.visible = false
	quest2.visible = false
	quest3.visible = false

	# If there are no quests, return
	if acceptedQuests.size() == 0:
		return
	
	# Show the quests
	for i in range(acceptedQuests.size()):
		if i == 0:
			showQuest(quest1, i, acceptedQuests)
		elif i == 1:
			showQuest(quest2, i, acceptedQuests)
		elif i == 2:
			showQuest(quest3, i, acceptedQuests)
	pass

func showQuest(quest: CanvasItem, index: int, acceptedQuests: Array[Quest]):
	quest.visible = true
	var completedCount = 0
	for j in range(3):
		if j < acceptedQuests[index].questInfo.objectives.size():
			quest.get_node("Objective" + str(j + 1)).visible = true
			quest.get_node("Objective" + str(j + 1)).text = "- " + acceptedQuests[index].questInfo.objectives[j].text
			if acceptedQuests[index].questInfo.objectives[j].completed:
				quest.get_node("Objective" + str(j + 1)).modulate = Color("00ff00")
				completedCount += 1
			else:
				quest.get_node("Objective" + str(j + 1)).modulate = Color("ffffff")
		else:
			quest.get_node("Objective" + str(j + 1)).visible = false
	
	if completedCount == acceptedQuests[index].questInfo.objectives.size():
		quest.get_node("Title").modulate = Color("00ff00")
		quest.get_node("Title").text = acceptedQuests[index].questInfo.name + " (Completed):"
	else:
		quest.get_node("Title").modulate = Color("ffffff")
		quest.get_node("Title").text = acceptedQuests[index].questInfo.name + ":"
