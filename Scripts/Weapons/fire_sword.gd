class_name FireSword
extends Weapon


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
	

func _on_animation_player_animation_finished(_anim_name):
	# Nascondo e Disattivo il nodo
	get_node(".").visible = false
	$CollisionShape2D.disabled = true

	weaponReady.emit()
