class_name QuestManager
extends Node

var availableQuests: Array[Quest] = []
var acceptedQuests: Array[Quest] = []
var completedQuests: Array[Quest] = []
var deliveredQuests: Array[Quest] = []

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
    
	ui.updateQuests(acceptedQuests)

func on_quest_completed(quest: Quest):
	print("Quest completed: ", quest.questInfo.name)
	acceptedQuests.erase(quest)
	completedQuests.append(quest)

func on_quest_delivered(quest: Quest):
	print("Quest delivered: ", quest.questInfo.name)
	completedQuests.erase(quest)
	deliveredQuests.append(quest)

## Accept a quest by id
func accept_quest(id: int):
	for quest in availableQuests:
		if quest.questInfo.id == id:
			quest.accept()
			break
