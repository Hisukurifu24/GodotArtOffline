class_name Weapon
extends Area2D

signal weaponUsed()
signal weaponReady()

var player: Character

@export var damage := 10
@export var knockbackForce := 250

var isWeaponReady = true

func _ready():
	player = get_tree().get_first_node_in_group("Player")

	weaponUsed.connect(_on_weapon_used)
	weaponReady.connect(_on_weapon_ready)
	area_entered.connect(_on_area_entered)
	pass

func use():
	weaponUsed.emit()
	pass

func _input(event):
	if event.is_action_released("useWeapon") and isWeaponReady:
		use()

func _on_weapon_used():
	isWeaponReady = false
	player.isAttacking = true
	pass

func _on_weapon_ready():
	isWeaponReady = true
	player.isAttacking = false
	pass

func _on_area_entered(area):
	# Controllo che il bersaglio sia valido
	if area is Hitbox:
		var hitbox: Hitbox = area
		
		hitbox.damage(damage) # Infliggo il danno
		
		# Se il bersagio è un entità applico un knockback
		if hitbox.damageable is Entity:
			var entity: Entity = hitbox.damageable
			
			entity.apply_knockback(global_position, knockbackForce)
