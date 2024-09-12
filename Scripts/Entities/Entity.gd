class_name Entity
extends CharacterBody2D

#region Variabili principali

@export var baseStats: Stats = Stats.new()
var currentStats: Stats = Stats.new()
var bonusStats: Stats = Stats.new()
var maxStats: Stats = Stats.new():
	get:
		return Stats.sum(baseStats, bonusStats)

var xp = 0:
	set(value):
		xp = value
		xp_changed.emit(xp, max_xp, lvl)
var max_xp = 100:
	set(value):
		max_xp = value
		xp_changed.emit(xp, max_xp, lvl)
var lvl = 1:
	set(value):
		lvl = value
		xp_changed.emit(xp, max_xp, lvl)

@export var speed = 100.0

var stamina = 100:
	set(value):
		stamina = clamp(value, 0, 100)
		stamina_changed.emit(stamina)
#endregion

#region Segnali
signal xp_changed(xp, max_xp, lvl)
signal stamina_changed(stamina)

signal died(entity)
#endregion

var is_alive = true
var knockbackTime = 0.5

func _ready():
	currentStats.copy(baseStats)
	bonusStats = Stats.new()

func takeDamage(amount):
	currentStats.hp -= amount
	changeColor()
	if (currentStats.hp == 0) and is_alive:
		die()

func heal(amount):
	currentStats.hp += amount
	if (currentStats.hp > maxStats.hp):
		currentStats.hp = maxStats.hp

func restoreMana(amount):
	currentStats.mana += amount
	if (currentStats.mana > maxStats.mana):
		currentStats.mana = maxStats.mana

func gainXP(amount):
	xp += amount
	while (xp >= max_xp):
		xp -= max_xp
		lvlup()
		max_xp *= 1.2

func lvlup():
	lvl += 1
	var statsIncrement = Stats.new(100, 50, 2, 2, 1, 1, 0, 0)
	baseStats.increase(statsIncrement)

func changeColor():
	$AnimatedSprite2D.modulate = Color(1, 0, 0) # Change color to red
	await get_tree().create_timer(0.5).timeout # Wait for 0.5 seconds
	$AnimatedSprite2D.modulate = Color(1, 1, 1) # Change color back to normal

func _process(delta):
	if (knockbackTime > 0):
		knockbackTime -= delta
	else:
		velocity = Vector2()

func die():
	died.emit(self)
	is_alive = false

func apply_knockback(attackerPos, power):
	if is_alive:
		knockbackTime = 0.5
		var knockback_direction = (global_position - attackerPos).normalized()
		velocity = knockback_direction * power
		move_and_slide()
