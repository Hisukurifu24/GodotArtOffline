class_name Hitbox
extends Area2D

@export var damageable: PhysicsBody2D

func damage(amount):
	# Se è un'entità subisce danno
	if damageable is Entity:
		var entity: Entity = damageable
		
		entity.takeDamage(amount) # Infliggo il danno
	
	# Altrimenti può avere altri effetti
#	else damageable is Object		ESEMPIO
#		object.break()				ESEMPIO
