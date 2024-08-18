extends PlatformRow
class_name BreakableObstacle
signal broke_platform

func _process(_delta: float) -> void:
	if not has_passed_spawn_threshold and position.y < SPAWN_THRESHOLD_Y:
		emit_signal("passed_spawn_threshold")
		has_passed_spawn_threshold = true

func _on_tree_exiting() -> void:
	emit_signal("passed_score_threshold")
	emit_signal("broke_platform")
