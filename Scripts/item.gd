class_name Item
extends Resource

## Nome dell'oggetto
@export var name: String = ""

## Descrizione dell'oggetto
@export_multiline var description: String = ""

## Icona dell'oggetto
@export var icon: Texture2D

## Statistiche dell'oggetto
@export var stats: Stats = Stats.new()
