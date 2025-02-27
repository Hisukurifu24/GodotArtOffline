class_name FireSword
extends Weapon

@export var fireScene: PackedScene;


func use():
	super.use()
	Swipe()
	pass

func Swipe():
	# Mostro e Attivo il nodo
	get_node(".").visible = true
	$CollisionShape2D.disabled = false
	
	# Get the direction vector from the sword to the cursor position
	var direction = get_global_mouse_position() - global_position
	# Calculate the angle between the sword and the cursor position
	var angle = rad_to_deg(direction.angle())
	# Set the rotation of the sword sprite to face towards the cursor position
	rotation = angle
	
	# Play the correct animation
	$AnimationPlayer.play("attack")

	# Instantiate 3 fireballs and shoot them in the direction of the cursor
	for i in range(3):
		var fireball: Flame = fireScene.instantiate()
		fireball.weapon = self
		fireball.global_position = global_position
		fireball.rotation = angle + 45 * i
		fireball.move_and_collide(direction.normalized() * 500)
		get_parent().add_child(fireball)

	
func _on_animation_player_animation_finished(_anim_name):
	# Nascondo e Disattivo il nodo
	get_node(".").visible = false
	$CollisionShape2D.disabled = true

	weaponReady.emit()
