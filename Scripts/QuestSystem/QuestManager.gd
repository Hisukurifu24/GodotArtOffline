class_name QuestManager
extends Node

@warning_ignore("unused_signal")
signal enemy_killed(enemy: Enemy)

@warning_ignore("unused_signal")
signal item_collected(item: Item)

var availableQuests: Array[Quest] = []
var acceptedQuests: Array[Quest] = []
var completedQuests: Array[Quest] = []
var deliveredQuests: Array[Quest] = []
var followQuest: Quest

var ui: CanvasLayer

func _ready():
	ui = get_node("/root/Scena/UI")

func on_quest_available(quest: Quest):
	print("Quest available: ", quest.questInfo.name)
	availableQuests.append(quest)

func on_quest_accepted(quest: Quest):
	print("Quest accepted: ", quest.questInfo.name)
	availableQuests.erase(quest)
	acceptedQuests.append(quest)

	# Set the quest as the quest as following
	followQuest = quest
    
	ui.updateQuests()

func on_objective_completed(objective: QuestObjective):
	print("Objective completed: " + objective.text)

	ui.updateQuests()

func on_objective_progressed(_objective: QuestObjective):
	ui.updateQuests()

func on_quest_completed(quest: Quest):
	print("Quest completed: ", quest.questInfo.name)
	acceptedQuests.erase(quest)
	completedQuests.append(quest)

func on_quest_delivered(quest: Quest):
	print("Quest delivered: ", quest.questInfo.name)
	completedQuests.erase(quest)
	deliveredQuests.append(quest)

	# Check if the delivered quest is the quest being followed
	if quest == followQuest:
		# Stop following the quest
		followQuest = null

	ui.updateQuests()

## Accept a quest by id
func accept_quest(id: int):
	for quest in availableQuests:
		if quest.questInfo.id == id:
			quest.accept()
			break

func deliver_quest(id: int):
	for quest in completedQuests:
		if quest.questInfo.id == id:
			quest.deliver()
			break

func is_delivered(id: int):
	for quest in deliveredQuests:
		if quest.questInfo.id == id:
			return true
	return false

func is_completed(id: int):
	for quest in completedQuests:
		if quest.questInfo.id == id:
			return true
	return false

func _on_chest_opened():
	# if has_node("QuestTriggerComponent"):
	# 	if get_node("QuestTriggerComponent").type == QuestObjective.ObjectiveType.COLLECT:
	# 		get_node("QuestTriggerComponent")._on_trigger()
	pass
