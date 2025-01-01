extends Node


var _battlers: Array[Battler] = []
var _is_over: bool = false


func _init() -> void:
	_battlers.append(Battler.new("Ally", Statistics.new(100)))
	_battlers.append(Battler.new("Enemy", Statistics.new(50)))

	for battler: Battler in _battlers:
		battler.was_knocked_out.connect(_on_battler_was_knocked_out)

	while not _is_over:
		_battlers[0].attack(_battlers[1])

		if _is_over:
			break

		_battlers[1].attack(_battlers[0])

		if _is_over:
			break

	print("The battle is over.")


func _on_battler_was_knocked_out() -> void:
	_is_over = true


class Battler extends RefCounted:
	signal was_knocked_out

	var _display_name: String
	var _statistics: Statistics


	func _init(display_name: String, statistics: Statistics) -> void:
		_display_name = display_name
		_statistics = statistics

		_statistics.hit_points_depleted.connect(_on_hit_points_depleted)


	func attack(target: Battler) -> void:
		print(_display_name + " attacks " + target.get_display_name() + ".")

		var damage: int = 10

		print(target.get_display_name() + " took " + str(damage) + " damage.")

		var target_statistics: Statistics = target.get_statistics()
		var target_hit_points: int = target_statistics.get_hit_points()
		target_hit_points -= damage
		target_statistics.set_hit_points(target_hit_points)


	func get_display_name() -> String:
		return _display_name


	func get_statistics() -> Statistics:
		return _statistics


	func _on_hit_points_depleted() -> void:
		print(_display_name + " was knocked out.")

		was_knocked_out.emit()
