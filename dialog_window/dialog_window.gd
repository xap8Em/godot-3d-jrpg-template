extends PanelContainer


signal confirmed

@onready var _label: Label = $Label


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		confirmed.emit()


func set_text(value: String) -> void:
	_label.set_text(value)
