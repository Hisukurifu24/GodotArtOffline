extends StaticBody2D

## Quest needed to unlock the wall
@export var quest: Quest
## Status the quest need to reach to unlock the wall
@export var questStatus: Quest.QuestStatus

func _ready():
	match questStatus:
		Quest.QuestStatus.AVAILABLE:
			quest.quest_available.connect(on_quest_status_reached)
		Quest.QuestStatus.ACCEPTED:
			quest.quest_accepted.connect(on_quest_status_reached)
		Quest.QuestStatus.COMPLETED:
			quest.quest_completed.connect(on_quest_status_reached)
		Quest.QuestStatus.DELIVERED:
			quest.quest_delivered.connect(on_quest_status_reached)
		_:
			printerr("Quest status not recognized")
	pass

## Called when the quest status is reached, remove the wall
func on_quest_status_reached(_questReached: Quest):
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true