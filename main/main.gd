class_name Main
extends Node


var _state_machine: StateMachine
var _window_mode_is_fullscreen: bool
var _mouse_mode_is_captured: bool


func _init() -> void:
	_state_machine = preload("res://main/state_machine.gd").new(self)

	_window_mode_is_fullscreen = bool(DisplayServer.window_get_mode())

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_mouse_mode_is_captured = true


func _input(event: InputEvent) -> void:
	_state_machine.input(event)


func _process(delta: float) -> void:
	_state_machine.process(delta)


func toggle_window_mode() -> void:
	_window_mode_is_fullscreen = not _window_mode_is_fullscreen
	DisplayServer.window_set_mode(3 * int(_window_mode_is_fullscreen))


func toggle_mouse_mode() -> void:
	_mouse_mode_is_captured = not _mouse_mode_is_captured
	Input.set_mouse_mode(2 * int(_mouse_mode_is_captured))
