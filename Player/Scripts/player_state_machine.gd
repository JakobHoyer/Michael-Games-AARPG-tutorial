class_name PlayerStateMachine extends Node

var states : Array[State]
var previous_state : State
var current_state : State


# Called when the node enters the scene tree for the first time
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED # disable this entire node
	pass

func _process(delta: float) -> void:
	change_state(current_state.process(delta))
	pass

func _physics_process(delta: float) -> void:
	change_state(current_state.physics(delta))
	pass

func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))
	pass

func initialize(_player : Player) -> void:
	states = []
	
	# find valid states from nodes
	for c in get_children():
		if c is State:
			states.append(c)
	
	if states.size() == 0:
		return
	
	states[0].player = _player
	states[0].state_machine = self
	
	for state in states:
		state.init()
	
	change_state(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT
	pass


func change_state(new_state : State) -> void:
	if new_state == null || new_state == current_state:
		return

	# Exit current state
	if current_state:
		current_state.exit()
	
	# Save data and enter new current state.
	previous_state = current_state
	current_state = new_state
	current_state.enter()
	pass
