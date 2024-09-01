class_name QuestKillObjective
extends QuestObjective

@export var target: GDScript
@export var amount: int = 1
var currentAmount: int = 0

func connect_signals():
	Quest_Manager.enemy_killed.connect(_on_enemy_killed)

func _on_enemy_killed(enemy):
	if enemy.get_script().get_global_name() == target.get_global_name():
		# Increase the current amount (up to the amount required)
		currentAmount = min(amount, currentAmount + 1)
		# Emit signal
		objective_progressed.emit(self)

		# Check if the objective is completed
		if currentAmount >= amount:
			completed = true
		pass
	pass
