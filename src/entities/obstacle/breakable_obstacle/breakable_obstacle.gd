extends PlatformRow
class_name BreakableObstacle

func _process(_delta: float) -> void:
	if not has_passed_spawn_threshold and position.y < SPAWN_THRESHOLD_Y:
		passed_spawn_threshold.emit()
		has_passed_spawn_threshold = true

func _on_tree_exiting() -> void:
	passed_score_threshold.emit()
	broke_platform.emit()
