extends PanelContainer


signal command_selected(command_index: int)

var _default_button: Button

@onready var _vbox_container: VBoxContainer = $VBoxContainer


func _ready() -> void:
	for i: int in _vbox_container.get_child_count():
		var button: Node = _vbox_container.get_child(i)

		assert(button)

		button.pressed.connect(_on_button_pressed.bind(i))

	_default_button = _vbox_container.get_child(0)

	assert(_default_button)


func display_commands() -> int:
	show()

	_default_button.grab_focus.call_deferred()

	var selected_command_index: int = await command_selected

	hide()

	return selected_command_index


func _on_button_pressed(command_index: int) -> void:
	command_selected.emit(command_index)
