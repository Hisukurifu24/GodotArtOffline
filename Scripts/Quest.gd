class_name Quest
extends Node

enum QuestStatus {INACTIVE, ACCEPTED, COMPLETED, DELIVERED}

## Informazioni sulla quest
@export var questInfo: QuestInfo
## Stato della quest
var status: QuestStatus = QuestStatus.INACTIVE

signal quest_accepted
signal quest_completed
signal quest_delivered

func accept():
	status = QuestStatus.ACCEPTED
	# Emit signal
	quest_accepted.emit()

func complete():
	status = QuestStatus.COMPLETED
	# Emit signal
	quest_completed.emit()

func deliver():
	status = QuestStatus.DELIVERED
	# Emit signal
	quest_delivered.emit()