class_name QuestInfo
extends Resource

@export var id: int
## Nome della quest
@export_multiline var name: String = ""
## Descrizione della quest
@export_multiline var description: String = ""
## Obiettivi della quest
@export var objectives: Array[QuestObjective] = []
## Ricompensa della quest
@export var reward: Reward

@export_group("Requisiti")
## Livello minimo richiesto per accettare la quest
@export var min_level: int = 1
## Quest richieste per accettare la quest
@export var required_quests: Array[QuestInfo] = []
