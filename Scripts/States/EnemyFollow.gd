class_name EnemyFollow
extends EnemyState

@export var attackDistance := 25
@export var outOfViewDistance := 50

func StatePhysicsUpdate(_delta: float):
	var direction = player.global_position - enemy.global_position

	# If the player is out of view, transition to idle
	if direction.length() > outOfViewDistance:
		Transitioned.emit(self, "idle")
	# If the player is out of attack distance, move towards the player
	elif direction.length() > attackDistance:
		enemy.velocity = direction.normalized() * enemy.speed
	# If the player is within attack distance, transition to attack
	else:
		enemy.velocity = Vector2.ZERO
		Transitioned.emit(self, "attack")
