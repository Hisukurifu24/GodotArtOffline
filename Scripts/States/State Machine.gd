extends Node

@export var entity: Entity
@export var initialState: State

var current_state: State
var states: Dictionary = {}

func _ready():
	entity.died.connect(on_entity_died)

	# Find all child states and connect their Transitioned signal
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)

	if initialState:
		current_state = initialState
		current_state.Enter()

func _process(delta):
	if current_state and entity.is_alive:
		current_state.StateUpdate(delta)

func _physics_process(delta):
	if current_state and entity.is_alive:
		current_state.StatePhysicsUpdate(delta)

# Called when the current state transitions to a new state
# This function will call the Exit function of the current state
# and the Enter function of the next state
func on_child_transitioned(state, next_state_name):
	if state != current_state:
		return
	
	var next_state = states[next_state_name.to_lower()]
	if next_state:
		if current_state:
			current_state.Exit()
		next_state.Enter()
		current_state = next_state

# Called when the entity dies
# This function will call the Exit function of the current state
# and set the current state to null
func on_entity_died():
	if current_state:
		current_state.Exit()
	current_state = null
