extends Node2D

@export var characterSprite: AnimatedSprite2D
var player: Character
var weapon: Weapon

var isWeaponReady = true

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	weapon = find_children("*", "Weapon")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Ruoto l'arma solo se non la sto già usando
	if (isWeaponReady):
		# Controllo se è collegato un controller
		if Input.get_connected_joypads().size() > 0:
			# Se è collegato un controller, ruoto l'arma verso la direzione del secondo joystick
			var aim: Vector2 = Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), Input.get_joy_axis(0, JOY_AXIS_LEFT_Y))
			if aim.length() > 0.1:
				look_at(global_position + Vector2(aim.x, aim.y))
		else:
			# Se non è collegato un controller, ruoto l'arma verso il mouse
			look_at(get_global_mouse_position())
	else:
		# Mentre uso l'arma, cambio la sprite del giocatore verso la stessa direzione 
		if global_rotation_degrees >= -45 and global_rotation_degrees < 45:
			characterSprite.play("idle_side")
			player.dirstring = "side"
			characterSprite.flip_h = false
		elif global_rotation_degrees >= 45 and global_rotation_degrees < 135:
			characterSprite.play("idle_front")
			player.dirstring = "front"
		elif global_rotation_degrees >= 135 or global_rotation_degrees < -135:
			characterSprite.play("idle_side")
			player.dirstring = "side"
			characterSprite.flip_h = true
		elif global_rotation_degrees >= -135 and global_rotation_degrees < -45:
			characterSprite.play("idle_back")
			player.dirstring = "back"
			
	
func _on_sword_weapon_used():
	isWeaponReady = false
	pass # Replace with function body.


func _on_sword_weapon_ready():
	isWeaponReady = true
	pass # Replace with function body.
