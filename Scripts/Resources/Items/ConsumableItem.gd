class_name ConsumableItem
extends Item

## Quanità di acqua fornita dall'oggetto
@export var water: int = 0

## Quanità di energia fornita dall'oggetto
@export var energy: int = 0

## Se l'oggetto è un buff temporaneo
@export var isBuff: bool = false

## Se l'oggetto è un buff temporaneo: durata in secondi.
## Se l'oggetto non è un buff, il tempo in cui l'effetto viene spalmato. (uno = istantaneo)
@export var duration: int = 1:
	set(value):
		duration = max(1, value)