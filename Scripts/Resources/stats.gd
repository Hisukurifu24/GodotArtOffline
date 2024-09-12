class_name Stats
extends Resource

signal stats_changed()

## Health Points
@export var hp: float:
	set(value):
		hp = max(value, 0)
		stats_changed.emit()
## Mana Points
@export var mp: float:
	set(value):
		mp = max(value, 0)
		stats_changed.emit()

## Attack Damage
@export var ad: float:
	set(value):
		ad = max(value, 0)
		stats_changed.emit()
## Ability Power
@export var ap: float:
	set(value):
		ap = max(value, 0)
		stats_changed.emit()

## Armor
@export var armor: float:
	set(value):
		armor = max(value, 0)
		stats_changed.emit()
## Magic Resistance
@export var mr: float:
	set(value):
		mr = max(value, 0)
		stats_changed.emit()

## Critical Strike Chance [0, 1]
@export_range(0, 1) var crit: float:
	set(value):
		crit = clamp(value, 0, 1)
		stats_changed.emit()
# Critical Strike Chance in percentage
var crit_pt: float:
	get:
		return crit * 100
	set(value):
		crit = value / 100
		stats_changed.emit()
## Critical Strike Damage [1, 3]
@export_range(1, 3) var crit_dmg: float:
	set(value):
		crit_dmg = clamp(value, 1, 3)
		stats_changed.emit()
## Critical Strike Damage in percentage
var crit_dmg_pt: int:
	get:
		return int(crit_dmg) * 100
	set(value):
		crit_dmg = float(value) / 100
		stats_changed.emit()


# TODO: Da definire come funziona esattamente il crit_dmg:
# damage = ad * (1 + crit_dmg * crit) = ad + ad * crit_dmg * is_crit[0, 1]
# sum crit damage: self.crit_dmg * added_crit_dmg?

# Returns a new Stats object
func _init(hp_init = 0, mp_init = 0, ad_init = 0, ap_init = 0, armor_init = 0, mr_init = 0, crit_init = 0, crit_dmg_init = 1):
	self.hp = hp_init
	self.mp = mp_init
	self.ad = ad_init
	self.ap = ap_init
	self.armor = armor_init
	self.mr = mr_init
	self.crit = crit_init
	self.crit_dmg = crit_dmg_init
	pass

# Returns a new Stats object with the sum of the stats of the two objects
static func sum(stats1: Stats, stats2: Stats):
	var summed_stats = stats1.duplicate()
	summed_stats.hp += stats2.hp
	summed_stats.mp += stats2.mp
	summed_stats.ad += stats2.ad
	summed_stats.ap += stats2.ap
	summed_stats.armor += stats2.armor
	summed_stats.mr += stats2.mr
	summed_stats.crit = clamp(summed_stats.crit + stats2.crit, 0, 1)
	summed_stats.crit_dmg = clamp(summed_stats.crit_dmg + stats2.crit_dmg, 1, 3)
	return summed_stats

static func divide_num(stats: Stats, num: float):
	var divided_stats = stats.duplicate()
	divided_stats.hp /= num
	divided_stats.mp /= num
	divided_stats.ad /= num
	divided_stats.ap /= num
	divided_stats.armor /= num
	divided_stats.mr /= num
	divided_stats.crit /= num
	divided_stats.crit_dmg /= num
	return divided_stats

# Increase the stats of the object by the values of the parameter
func increase(values: Stats):
	self.hp += values.hp
	self.mp += values.mp
	self.ad += values.ad
	self.ap += values.ap
	self.armor += values.armor
	self.mr += values.mr
	self.crit = clamp(self.crit + values.crit, 0, 1)
	self.crit_dmg = clamp(self.crit_dmg + values.crit_dmg, 1, 3)

# Decrease the stats of the object by the values of the parameter
func decrease(values: Stats):
	self.hp -= values.hp
	self.mp -= values.mp
	self.ad -= values.ad
	self.ap -= values.ap
	self.armor -= values.armor
	self.mr -= values.mr
	self.crit = clamp(self.crit - values.crit, 0, 1)
	self.crit_dmg = clamp(self.crit_dmg - values.crit_dmg, 1, 3)

func copy(stats: Stats):
	self.hp = stats.hp
	self.mp = stats.mp
	self.ad = stats.ad
	self.ap = stats.ap
	self.armor = stats.armor
	self.mr = stats.mr
	self.crit = stats.crit
	self.crit_dmg = stats.crit_dmg
