class_name State
extends RefCounted


signal exiting(next_state_name: StringName)


func enter() -> void:
	pass


func input(_event: InputEvent) -> void:
	pass


func unhandled_input(_event: InputEvent) -> void:
	pass


func physics_process(_delta: float) -> void:
	pass


func process(_delta: float) -> void:
	pass


func exit() -> void:
	pass
