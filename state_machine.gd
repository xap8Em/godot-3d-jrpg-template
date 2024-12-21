class_name StateMachine
extends RefCounted


signal current_state_changed(current_state_name: StringName)

var _current_state: State
var _state_map: Dictionary


func _init(initial_state_name: StringName) -> void:
	_state_map.make_read_only()

	_current_state = _get_state(initial_state_name)


func input(event: InputEvent) -> void:
	_current_state.input(event)


func physics_process(delta: float) -> void:
	_current_state.physics_process(delta)


func process(delta: float) -> void:
	_current_state.process(delta)


func unhandled_input(event: InputEvent) -> void:
	_current_state.unhandled_input(event)


func _add_state(state_name: StringName, state: State) -> void:
	assert(not _state_map.has(state_name))

	state.exiting.connect(_change_current_state_to)

	_state_map[state_name] = state


func _change_current_state_to(next_state_name: StringName) -> void:
	var next_state: State = _get_state(next_state_name)

	_current_state.exit()
	_current_state = next_state
	_current_state.enter()

	current_state_changed.emit(_current_state.get_name())


func _get_state(state_name: StringName) -> State:
	var state: State = _state_map.get(state_name)

	assert(state)

	return state


class State extends RefCounted:
	signal exiting(next_state_name: StringName)


	func enter() -> void:
		pass


	func exit() -> void:
		pass


	func input(_event: InputEvent) -> void:
		pass


	func physics_process(_delta: float) -> void:
		pass


	func process(_delta: float) -> void:
		pass


	func unhandled_input(_event: InputEvent) -> void:
		pass
