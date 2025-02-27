class_name Flame
extends StaticBody2D

var weapon: Weapon
var direction: Vector2

func _ready():
	if !weapon:
		printerr("You tried to instantiate a weapon effect without a weapon")
		queue_free();
		return
	connect("area_entered", on_area_entered)

func _physics_process(delta: float) -> void:
	# Muovo il proiettile
	# move_and_slide(direction)
	# Se esco dallo schermo distruggo l'oggetto
	if !get_viewport_rect().has_point(global_position):
		queue_free()
	pass

func on_area_entered(area):
	# Controllo che il bersaglio sia valido
	if area is Hitbox:
		var hitbox: Hitbox = area
		
		hitbox.damage(weapon.damage) # Infliggo il danno
		
		# Se il bersagio è un entità applico un knockback
		if hitbox.damageable is Entity:
			var entity: Entity = hitbox.damageable
			
			entity.apply_knockback(global_position, weapon.knockbackForce)
	pass
