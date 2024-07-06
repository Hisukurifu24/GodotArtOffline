class_name Quest
extends Resource

enum QuestStatus {INACTIVE, ACCEPTED, COMPLETED, FAILED}

## Nome della quest
@export var name: String = ""
## Descrizione della quest
@export_multiline var description: String = ""
## Obiettivi della quest
@export_multiline var objectives: Array[String] = []
## Stato della quest
var status: QuestStatus = QuestStatus.INACTIVE
## Ricompensa della quest
@export var reward: Reward
