class_name EnemyIdle
extends EnemyState

@export var viewDistance := 50

var moveDir: Vector2
var wanderTime: float
var restTime: float

func randomize_wander():
	moveDir = Vector2(randf_range( - 1, 1), randf_range( - 1, 1)).normalized()
	wanderTime = randf_range(1, 3)
	restTime = randf_range(1, 3)

func Enter():
	super.Enter()
	randomize_wander()

func StateUpdate(delta: float):
	if wanderTime > 0:
		wanderTime -= delta
	elif restTime > 0:
		moveDir = Vector2.ZERO
		restTime -= delta
	else:
		randomize_wander()

func StatePhysicsUpdate(_delta: float):
	# Move the enemy
	if enemy:
		enemy.velocity = moveDir * enemy.speed
	
	var direction = player.global_position - enemy.global_position
	
	# Check if the player is in view
	if direction.length() < viewDistance:
		Transitioned.emit(self, "follow")
