class_name Statistics
extends RefCounted


signal hit_points_depleted

var _attack: int
var _defense: int
var _hit_points: int: set = set_hit_points
var _max_hit_points: int


func _init(attack: int, defense: int, max_hit_points: int) -> void:
	_attack = maxi(attack, 0)
	_defense = maxi(defense, 0)
	_max_hit_points = maxi(max_hit_points, 1)
	_hit_points = _max_hit_points


func get_attack() -> int:
	return _attack


func get_defense() -> int:
	return _defense


func get_hit_points() -> int:
	return _hit_points


func set_hit_points(value: int) -> void:
	_hit_points = clampi(value, 0, _max_hit_points)

	if value <= 0:
		hit_points_depleted.emit()
