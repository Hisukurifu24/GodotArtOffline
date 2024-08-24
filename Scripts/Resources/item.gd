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

## Numero massimo di oggetti impilabili
@export var maxStack: int = 1

## Rarità dell'oggetto
@export var rarity: Rarity = Rarity.COMMON

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY,
	ARTIFACT
}