extends PanelContainer


signal confirmed

var _is_message_displayed: bool = false

@onready var _label: Label = $Label


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and _is_message_displayed:
		_is_message_displayed = false

		confirmed.emit()


func display_message(message: String) -> void:
	_label.set_text(message)

	_is_message_displayed = true

	await confirmed
