class_name Statistics
extends RefCounted


signal hit_points_depleted

var _attack: int
var _defense: int
var _health: FractionStatistic


func _init(attack: int, defense: int, max_hit_points: int) -> void:
	_attack = maxi(attack, 0)
	_defense = maxi(defense, 0)
	_health = FractionStatistic.new(max_hit_points)

	_health.depleted.connect(_on_health_depleted)


func get_attack() -> int:
	return _attack


func get_defense() -> int:
	return _defense


func get_hit_points() -> int:
	return _health.get_points()


func set_hit_points(value: int) -> void:
	_health.set_points(value)


func _on_health_depleted() -> void:
	hit_points_depleted.emit()


class FractionStatistic extends RefCounted:
	signal depleted

	var _max_points: int: set = set_max_points
	var _points: int: set = set_points


	func _init(max_points: int) -> void:
		_max_points = max_points
		_points = _max_points


	func get_max_points() -> int:
		return _max_points


	func get_points() -> int:
		return _points


	func set_max_points(value: int) -> void:
		_max_points = max(value, 1)
		_points = mini(_points, _max_points)


	func set_points(value: int) -> void:
		_points = clampi(value, 0, _max_points)

		if _points <= 0:
			depleted.emit()
