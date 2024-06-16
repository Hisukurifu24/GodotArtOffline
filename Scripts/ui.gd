extends CanvasLayer

@onready var hpBar = $"Control/HP"
@onready var manaBar = $"Control/Mana"
@onready var energyBar = $"Control/Energia"
@onready var waterBar = $"Control/Sete"
@onready var expBar = $"Control/Exp"
@onready var staminaBar = $"Control/Stamina"
@onready var staminaTimer = $"StaminaHideTimer"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_character_health_changed(hp, max_hp):
	hpBar.max_value = max_hp
	hpBar.value = hp
	hpBar.get_node("Label").text = str(hp) + "/" + str(max_hp)

func _on_character_mana_changed(mana, max_mana):
	manaBar.max_value = max_mana
	manaBar.value = mana
	manaBar.get_node("Label").text = str(mana) + "/" + str(max_mana)

func _on_character_energy_changed(energy, max_energy):
	energyBar.max_value = max_energy
	energyBar.value = energy

func _on_character_water_changed(water, max_water):
	waterBar.max_value = max_water
	waterBar.value = water

func _on_character_xp_changed(xp, max_xp, lvl):
	expBar.max_value = max_xp
	expBar.value = xp
	expBar.get_node("Level").text = "lvl: " + str(lvl)

func _on_character_stamina_changed(stamina):
	if stamina < 25:
		staminaBar.get("theme_override_styles/fill").bg_color = Color("adad00")
	else:
		staminaBar.get("theme_override_styles/fill").bg_color = Color("ffff77")
	if stamina > 99:
		staminaTimer.start()
	else:
		staminaBar.visible = true
	staminaBar.value = stamina

func _on_stamina_hide_timer_timeout():
	staminaBar.visible = false
