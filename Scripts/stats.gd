class_name Stats
extends Resource

## Health Points
@export var hp: float:
	set(value):
		hp = max(value, 0)
## Mana Points
@export var mp: float:
	set(value):
		mp = max(value, 0)

## Attack Damage
@export var ad: float:
	set(value):
		ad = max(value, 0)
## Ability Power
@export var ap: float:
	set(value):
		ap = max(value, 0)

## Armor
@export var armor: float:
	set(value):
		armor = max(value, 0)
## Magic Resistance
@export var mr: float:
	set(value):
		mr = max(value, 0)

## Critical Strike Chance [0, 1]
@export_range(0, 1) var crit: float:
	set(value):
		crit = clamp(value, 0, 1)
# Critical Strike Chance in percentage
var crit_pt: float:
	get:
		return crit * 100
	set(value):
		crit = value / 100
## Critical Strike Damage [1, 3]
@export_range(1, 3) var crit_dmg: float:
	set(value):
		crit_dmg = clamp(value, 1, 3)

# Returns a new Stats object
func _init(hp_param=0, mp_param=0, ad_param=0, ap_param=0, armor_param=0, mr_param=0, crit_param=0, crit_dmg_param=1):
	self.hp = hp_param
	self.mp = mp_param
	self.ad = ad_param
	self.ap = ap_param
	self.armor = armor_param
	self.mr = mr_param
	self.crit = crit_param
	self.crit_dmg = crit_dmg_param

# Returns a new Stats object with the sum of the stats of the two objects
static func sum(stats1, stats2):
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
