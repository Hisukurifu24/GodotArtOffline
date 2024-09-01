extends Node
class_name State

@warning_ignore("unused_signal")
signal Transitioned

func Enter():
	pass

func Exit():
	pass

func StateUpdate(_delta: float):
	pass

func StatePhysicsUpdate(_delta: float):
	pass
