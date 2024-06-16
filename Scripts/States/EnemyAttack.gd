class_name EnemyAttack
extends EnemyState

@export var attackDistance := 25

func StatePhysicsUpdate(_delta: float):
	var direction = player.global_position - enemy.global_position

	# Check if the player is out of range
	if direction.length() > attackDistance:
		print("Out of range")
		Transitioned.emit(self, "follow")
	else:
		enemy.attack(player)
