extends CharacterBody2D
class_name DoublePlatform

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
