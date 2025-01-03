extends Node


const MessageWindow = preload("res://battle/message_window.gd")

var _battlers: Array[Battler] = []
var _is_over: bool = false

@onready var _message_window: MessageWindow = $MessageWindow


func _ready() -> void:
	_battlers.append(Battler.new("Ally", _message_window, Statistics.new(2, 2, 8)))
	_battlers.append(Battler.new("Enemy", _message_window, Statistics.new(1, 1, 4)))

	for battler: Battler in _battlers:
		battler.was_knocked_out.connect(_on_battler_was_knocked_out)

	for i: int in 16:
		await _battlers[0].attack(_battlers[1])

		if _is_over:
			break

		await _battlers[1].attack(_battlers[0])

		if _is_over:
			break

	await _message_window.display_message("The battle is over.")


func _on_battler_was_knocked_out() -> void:
	_is_over = true


class Battler extends RefCounted:
	signal was_knocked_out

	var _display_name: String
	var _message_window: MessageWindow
	var _statistics: Statistics


	func _init(display_name: String, message_window: MessageWindow, statistics: Statistics) -> void:
		_display_name = display_name
		_message_window = message_window
		_statistics = statistics

		_statistics.hit_points_depleted.connect(_on_hit_points_depleted)


	func attack(target: Battler) -> void:
		await _message_window.display_message(_display_name + " attacks " + target.get_display_name() + ".")

		var target_statistics: Statistics = target.get_statistics()

		var target_defense: int = target_statistics.get_defense()
		var damage: int = maxi(_statistics.get_attack() - target_defense, 0)

		await _message_window.display_message(target.get_display_name() + " took " + str(damage) + " damage.")

		var target_hit_points: int = target_statistics.get_hit_points()

		target_statistics.set_hit_points(target_hit_points - damage)


	func get_display_name() -> String:
		return _display_name


	func get_statistics() -> Statistics:
		return _statistics


	func _on_hit_points_depleted() -> void:
		await _message_window.display_message(_display_name + " was knocked out.")

		was_knocked_out.emit()
