extends State


var _main: Main


func _init(main: Main) -> void:
	_main = main


func input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_window_mode"):
		_main.toggle_window_mode()

	if event.is_action_pressed("pause"):
		_main.toggle_mouse_mode()
