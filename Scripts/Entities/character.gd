class_name Character
extends Entity

var energy = 100
@export var max_energy = 100

var water = 100
@export var max_water = 100

signal energy_changed(energy, max_energy)
signal water_changed(water, max_water)

#region Altre Variabili
@onready var sprite = $AnimatedSprite2D

var dirstring = "front"
var direction

var isSprinting = false
var isAttacking = false
#endregion

func _ready():
	super._ready()
	energy = max_energy
	water = max_water
	
	health_changed.emit(currentStats.hp, maxStats.hp)
	mana_changed.emit(currentStats.mp, maxStats.mp)
	print(energy)
	print(max_energy)
	energy_changed.emit(energy, max_energy)
	water_changed.emit(water, max_water)
	xp_changed.emit(xp, max_xp, lvl)
	stamina_changed.emit(stamina)

func _process(delta):
	# Load correct sprite based on direction
	if direction:
		dirstring = "front" if direction.y > 0 else "back"
		if direction.x != 0:
			dirstring = "side"
			if direction.x < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
		sprite.play("move_" + dirstring)
	else:
		sprite.play("idle_" + dirstring)
	
	# Decrease stamina when sprinting
	if isSprinting:
		if (stamina > 0):
			stamina -= delta * 30
			stamina_changed.emit(stamina)
		else:
			sprint(false)
	else:
		# Recover stamina otherwise
		if stamina < 100:
			stamina += delta * 5
			stamina_changed.emit(stamina)

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	direction = Vector2(Input.get_axis("moveLeft", "moveRight"), Input.get_axis("moveUp", "moveDown")).normalized()

	if direction and !isAttacking:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()

func sprint(value):
	# Sprinting is only possible if the player has enough stamina
	isSprinting = value
	speed = speed * 1.5 if isSprinting else speed / 1.5

func _input(event):
	if event.is_action_pressed("sprint"):
		if stamina > 25 and !isSprinting and direction != Vector2.ZERO:
			sprint(true)
	if event.is_action_released("sprint"):
		if isSprinting:
			sprint(false)
