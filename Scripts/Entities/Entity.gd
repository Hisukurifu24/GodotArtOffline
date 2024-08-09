class_name Entity
extends CharacterBody2D

#region Variabili principali

@export var baseStats: Stats = Stats.new()
var currentStats: Stats = Stats.new()
var bonusStats: Stats = Stats.new()
var maxStats: Stats = Stats.new():
	get:
		return Stats.sum(baseStats, bonusStats)

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
	currentStats.copy(baseStats)
	bonusStats = Stats.new()

func takeDamage(amount):
	currentStats.hp -= amount
	health_changed.emit(currentStats.hp, maxStats.hp)
	changeColor()
	if (currentStats.hp == 0):
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
