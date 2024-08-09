class_name Quest
extends Node

enum QuestStatus {INACTIVE, AVAILABLE, ACCEPTED, COMPLETED, DELIVERED}

## Informazioni sulla quest
@export var questInfo: QuestInfo

## Stato della quest
var status: QuestStatus = QuestStatus.INACTIVE

signal quest_available(quest: Quest)
signal quest_accepted(quest: Quest)
signal quest_completed(quest: Quest)
signal quest_delivered(quest: Quest)

var player: Character

func _ready():
	# Connect signals
	quest_delivered.connect(on_quest_delivered)

	quest_available.connect(Quest_Manager.on_quest_available)
	quest_accepted.connect(Quest_Manager.on_quest_accepted)
	quest_completed.connect(Quest_Manager.on_quest_completed)
	quest_delivered.connect(Quest_Manager.on_quest_delivered)

	# Get the player node
	player = get_tree().get_first_node_in_group("Player")

	# Check if quest is already available
	check_availability()

func accept():
	status = QuestStatus.ACCEPTED
	# Emit signal
	quest_accepted.emit(self)

func complete():
	status = QuestStatus.COMPLETED
	# Emit signal
	quest_completed.emit(self)

func deliver():
	status = QuestStatus.DELIVERED
	# Emit signal
	quest_delivered.emit(self)

# This function is called on every quest node when a quest is delivered
func on_quest_delivered(questDelivered: Quest):
	# Check if the delivered quest is a required quest
	if questInfo.required_quests.has(questDelivered.questInfo):
		# Remove the delivered quest from the required quests
		questInfo.required_quests.erase(questDelivered.questInfo)
		
		# Check if quest is now available
		check_availability()
	pass

func check_availability():
	if status == QuestStatus.INACTIVE:
		# Check if all required quests are completed
		# AND
		# Check if the player level is greater or equal to the minimum level required
		if questInfo.required_quests.is_empty() and player.lvl >= questInfo.min_level:
			# Set the quest status to AVAILABLE
			status = QuestStatus.AVAILABLE
			# Emit signal
			quest_available.emit(self)
	pass
