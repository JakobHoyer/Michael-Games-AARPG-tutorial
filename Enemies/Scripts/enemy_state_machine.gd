class_name EnemyStateMachine extends Node

var states : Array[EnemyState]
var previous_state : EnemyState
var current_state : EnemyState


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass

func _process(delta: float) -> void:
	change_state(current_state.process(delta))
	pass

func _physics_process(delta: float) -> void:
	change_state(current_state.physics(delta))
	pass


## Retrieve states and make sure the specific enemy is initialized
func initialize(_enemy : Enemy) -> void:
	states = []
	
	for c in get_children():
		if c is EnemyState:
			states.append(c)
	
	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.init()
	
	if states.size() > 0:
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT
	pass


func change_state(new_state : EnemyState) -> void:
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
