class_name Character
extends Entity

var energy = 100:
	set(value):
		energy = clamp(value, 0, max_energy)
		energy_changed.emit(energy, max_energy)
@export var max_energy = 100:
	set(value):
		max_energy = max(value, 0)
		energy = min(energy, max_energy)
		energy_changed.emit(energy, max_energy)

var water = 100:
	set(value):
		water = clamp(value, 0, max_water)
		water_changed.emit(water, max_water)
@export var max_water = 100:
	set(value):
		max_water = max(value, 0)
		water = min(water, max_water)
		water_changed.emit(water, max_water)

var gold: int = 0:
	set(value):
		gold = value
		gold_changed.emit(gold)

# Segnali
signal player_stats_changed()

signal energy_changed(energy, max_energy)
signal water_changed(water, max_water)
signal gold_changed(gold)

#region Movement Variables
@onready var sprite = $AnimatedSprite2D

var dirstring: String = "front"
var direction: Vector2 = Vector2.ZERO

var isSprinting := false
var isAttacking := false
#endregion

@export var profile_image: Texture = null

@onready var energy_timer = %EnergyTimer
@onready var water_timer = %WaterTimer


func _ready():
	super._ready()

	energy = max_energy
	water = max_water

	##Test
	Quest_Manager.accept_quest(2)

	# $Bag._init()
	$Bag.add_item(load("res://Resources/Items/Spada del Vecchio.tres"), 2)
	$Bag.add_item(load("res://Resources/Items/apple.tres"), 200)
	$Bag.add_item(load("res://Resources/Items/banana.tres"), 23)
	$Bag.add_item(load("res://Resources/Items/banana.tres"), 33)
	$Bag.insert_at(15, load("res://Resources/Items/banana.tres"), 33)
	$Bag.insert_at(16, load("res://Resources/Items/apple.tres"), 33)
	$Bag.insert_at(17, load("res://Resources/Items/banana.tres"), 66)

	# Connect signals
	baseStats.stats_changed.connect(_on_character_stats_changed)
	currentStats.stats_changed.connect(_on_character_stats_changed)
	bonusStats.stats_changed.connect(_on_character_stats_changed)
	maxStats.stats_changed.connect(_on_character_stats_changed)

	# Connect signals
	energy_timer.timeout.connect(_on_energy_timer_timeout)
	water_timer.timeout.connect(_on_water_timer_timeout)

	player_stats_changed.emit()
	energy_changed.emit(energy, max_energy)
	water_changed.emit(water, max_water)
	xp_changed.emit(xp, max_xp, lvl)
	stamina_changed.emit(stamina)
	gold_changed.emit(gold)

func _process(delta):
	# Load correct sprite based on direction
	if direction:
		dirstring = "front" if direction.y > 0 else "back"
		if direction.x != 0:
			dirstring = "side"
			sprite.flip_h = true if direction.x < 0 else false
		sprite.play("move_" + dirstring)
	else:
		sprite.play("idle_" + dirstring)
	
	# Decrease stamina when sprinting
	if isSprinting and direction != Vector2.ZERO:
		if (stamina > 0):
			stamina -= delta * 30
		else:
			sprint(false)
	else:
		# Recover stamina otherwise
		if stamina < 100:
			stamina += delta * 5
	

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
		if stamina > 25 and !isSprinting:
			sprint(true)
	if event.is_action_released("sprint"):
		if isSprinting:
			sprint(false)

func _on_character_stats_changed():
	player_stats_changed.emit()

func _on_energy_timer_timeout():
	energy -= 1

func _on_water_timer_timeout():
	water -= 1
