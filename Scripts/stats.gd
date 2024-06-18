class_name Stats

var hp: float:
	set(value):
		hp = max(value, 0)
var mp: float:
	set(value):
		mp = max(value, 0)

var ad: float:
	set(value):
		ad = max(value, 0)
var ap: float:
	set(value):
		ap = max(value, 0)

var armor: float:
	set(value):
		armor = max(value, 0)
var mr: float:
	set(value):
		mr = max(value, 0)

var speed: float:
	set(value):
		speed = max(value, 0)
		
var crit: float:
	set(value):
		crit = clamp(value, 0, 1)
var crit_pt: float:
	set(value):
		crit_pt = max(value, 0)

func _init(ad_param: float, ap_param: float, armor_param: float, mr_param: float, hp_param: float, mp_param: float):
	self.ad = ad_param
	self.ap = ap_param
	self.armor = armor_param
	self.mr = mr_param
	self.hp = hp_param
	self.mp = mp_param
	pass