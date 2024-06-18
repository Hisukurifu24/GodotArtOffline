class_name Entity
extends CharacterBody2D

#region Variabili principali
var hp = 1000
@export var max_hp = 1000

var mana = 1000
@export var max_mana = 1000

var xp = 0
var max_xp = 100
var lvl = 1

@export var speed = 100.0
var stamina = 100
#endregion

#region Segnali
signal health_changed(hp, max_hp)
signal mana_changed(mana, max_mana)
signal xp_changed(xp, max_xp, lvl)
signal stamina_changed(stamina)

signal died()
#endregion

var is_alive = true
var knockbackTime = 0.5

func _ready():
	hp = max_hp
	mana = max_mana

func takeDamage(amount):
	print("HP: " + str(hp) + " - " + str(amount))
	hp -= amount
	hp = clamp(hp, 0, max_hp)
	health_changed.emit(hp, max_hp)
	changeColor()
	if (hp == 0):
		die()

func changeColor():
	modulate = Color(1, 0, 0) # Change color to red
	await get_tree().create_timer(0.5).timeout
	modulate = Color(1, 1, 1) # Change color back to normal

func _process(delta):
	if (knockbackTime > 0):
		knockbackTime -= delta
	else:
		velocity = Vector2()

func die():
	died.emit()
	is_alive = false

func apply_knockback(attackerPos, power):
	if is_alive:
		knockbackTime = 0.5
		var knockback_direction = (global_position - attackerPos).normalized()
		velocity = knockback_direction * power
		move_and_slide()
