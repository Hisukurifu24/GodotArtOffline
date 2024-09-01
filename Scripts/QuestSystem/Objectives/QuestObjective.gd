class_name QuestObjective
extends Resource

signal objective_completed(objective: QuestObjective)
signal objective_progressed(objective: QuestObjective)

@export_multiline var text: String = ""

func _init():
	objective_completed.connect(Quest_Manager.on_objective_completed)
	objective_progressed.connect(Quest_Manager.on_objective_progressed)

# Emit signal when the objective is completed
var completed: bool = false:
	set(value):
		completed = value
		if completed:
			objective_completed.emit(self)

# Abstract function to be implemented in child classes
func connect_signals():
	pass