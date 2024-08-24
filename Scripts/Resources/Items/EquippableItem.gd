class_name EquippableItem
extends Item

## Texture dell'icona dell'oggetto per ogni livello di potenziamento in ordine crescente
@export var upgradedIcons: Array[Texture2D] = []

## Livello dell'oggetto
var level: int = 1

## Livello massimo dell'oggetto
var maxLevel: int:
	get:
		return upgradedIcons.size() + 1