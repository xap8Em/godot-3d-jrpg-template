class_name Statistics
extends RefCounted


signal hit_points_depleted

var _hit_points: int: set = set_hit_points
var _max_hit_points: int


func _init(max_hit_points: int) -> void:
	_max_hit_points = max_hit_points
	_hit_points = _max_hit_points


func get_hit_points() -> int:
	return _hit_points


func set_hit_points(value: int) -> void:
	_hit_points = clampi(value, 0, _max_hit_points)

	if value <= 0:
		hit_points_depleted.emit()
