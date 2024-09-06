class_name Slot

var item: Item = null:
	set(value):
		item = value
		if item:
			quantity = 1
		else:
			quantity = 0
var quantity: int = 0:
	set(value):
		if item and value > item.maxStack:
			printerr("item quantity exceeds max stack")
		if value < 0:
			printerr("quantity cannot be negative")
		quantity = value

func _init(_item: Item = null, _quantity: int = 0):
	item = _item
	quantity = _quantity

func setSlot(_item: Item, _quantity: int):
	self.item = _item
	self.quantity = _quantity
