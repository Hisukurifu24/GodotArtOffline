class_name QuestKillObjective
extends QuestObjective

@export var target: PackedScene
@export var amount: int = 1

func connect_signals():
	Quest_Manager.enemy_killed.connect(_on_enemy_killed)

func _on_enemy_killed(enemy):
	if enemy.is_in_group("Enemy") and target.is_class(enemy.get_class()):
		amount -= 1
		if amount <= 0:
			completed = true
		pass
	pass