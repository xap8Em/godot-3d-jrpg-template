extends Node


const CommandMenu = preload("res://battle/command_menu.gd")
const MessageWindow = preload("res://battle/message_window.gd")

var _is_over: bool = false

@onready var _command_menu: CommandMenu = $CommandMenu
@onready var _message_window: MessageWindow = $MessageWindow


func _ready() -> void:
	var battlers: Array[Battler] = []

	battlers.append(Battler.new(_command_menu, "Ally", _message_window, Statistics.new(2, 2, 8)))
	battlers.append(Battler.new(_command_menu, "Enemy", _message_window, Statistics.new(1, 1, 4)))

	_begin(battlers)


func _begin(battlers: Array[Battler]) -> void:
	for battler: Battler in battlers:
		battler.was_knocked_out.connect(_on_battler_was_knocked_out)

	_proceed_with_round(battlers)


func _end() -> void:
	await _message_window.display_message("The battle is over.")

	get_tree().quit()


func _on_battler_was_knocked_out() -> void:
	_is_over = true


func _proceed_with_round(battlers: Array[Battler]) -> void:
	await _proceed_with_turn(battlers, 0)

	_proceed_with_round(battlers)


func _proceed_with_turn(battlers: Array[Battler], active_battler_index: int) -> void:
	var target: Battler = battlers[active_battler_index - 1]

	await battlers[active_battler_index].attack(target)

	if _is_over:
		_end()

	active_battler_index += 1

	if active_battler_index == battlers.size():
		return

	_proceed_with_turn(battlers, active_battler_index)


class Battler extends RefCounted:
	signal was_knocked_out

	var _command_menu: CommandMenu
	var _display_name: String
	var _message_window: MessageWindow
	var _statistics: Statistics


	func _init(command_menu: CommandMenu, display_name: String, message_window: MessageWindow, statistics: Statistics) -> void:
		_command_menu = command_menu
		_display_name = display_name
		_message_window = message_window
		_statistics = statistics

		_statistics.hit_points_depleted.connect(_on_hit_points_depleted)


	func attack(target: Battler) -> void:
		var command_index: int = await _command_menu.display_commands()

		if command_index != 0:
			return

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
