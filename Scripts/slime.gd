extends Enemy

@onready var sprite = $AnimatedSprite2D

func _process(_delta):
	if !is_alive:
		return
	if velocity != Vector2.ZERO:
		sprite.play("move")
	else:
		if is_attacking:
			sprite.play("attack")
		else:
			sprite.play("idle")
	if velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func die():
	super.die()
	sprite.play("death")
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _physics_process(_delta):
	move_and_slide()