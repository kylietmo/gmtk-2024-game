extends Obstacle
class_name PlatformRow
signal passed_score_threshold
signal passed_spawn_threshold

var has_passed_score_threshold = false
var has_passed_spawn_threshold = false

func _process(delta: float) -> void:
	if not has_passed_score_threshold and position.y < Globals.PLAYER_START_Y:
		emit_signal("passed_score_threshold")
		has_passed_score_threshold = true
	
	if not has_passed_spawn_threshold and position.y < 50:
		emit_signal("passed_spawn_threshold")
		has_passed_spawn_threshold = true
