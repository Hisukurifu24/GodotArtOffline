class_name Enemy
extends Entity

var is_attacking := false
@export var damage := 100
## The time between each attack in seconds
@export var attackCooldown := 1.0

func _ready():
	super._ready()
	add_to_group("Enemy")

func attack(target: Entity):
	# Skip attack if already attacking
	if !is_attacking:
		is_attacking = true # Set attack state
		target.takeDamage(damage) # Deal damage to target
		await get_tree().create_timer(attackCooldown).timeout # Wait for cooldown
		is_attacking = false # Reset attack state

func die():
	Quest_Manager.enemy_killed.emit(self)
	super.die()