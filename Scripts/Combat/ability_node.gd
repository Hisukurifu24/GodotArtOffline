class_name AbilityNode extends Node2D

signal abilityFinished();

@onready var animationPlayer: AnimationPlayer = %"AnimationPlayer"

func _ready():
	animationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_anim_name) -> void:
	abilityFinished.emit()
