class_name AbilityNode extends Node2D

signal abilityFinished();

var animationPlayer: AnimationPlayer

func _init():
	animationPlayer = get_node("AnimationPlayer")

func _ready():
	animationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_anim_name) -> void:
	abilityFinished.emit()
