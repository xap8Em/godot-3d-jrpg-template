extends StateMachine


func _init(main: Main) -> void:
	_add_state(&"state", preload("res://main/states/state.gd").new(main))

	super(&"state")
