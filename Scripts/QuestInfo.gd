class_name QuestInfo
extends Resource

## Nome della quest
@export var name: String = ""
## Descrizione della quest
@export_multiline var description: String = ""
## Obiettivi della quest
@export_multiline var objectives: Array[String] = []
## Ricompensa della quest
@export var reward: Reward