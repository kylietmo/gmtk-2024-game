extends PlatformRow
class_name BreakableObstacle
signal broke_platform

func _process(_delta: float) -> void:
	pass

func _on_tree_exiting() -> void:
	emit_signal("passed_score_threshold")
	emit_signal("passed_spawn_threshold")
	emit_signal("broke_platform")
