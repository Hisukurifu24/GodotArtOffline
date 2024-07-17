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

@export_category("Requisiti")
## Livello minimo richiesto per accettare la quest
@export var min_level: int = 1
## Quest richieste per accettare la quest
@export var required_quests: Array[QuestInfo] = []