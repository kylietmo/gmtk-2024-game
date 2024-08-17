extends CharacterBody2D
class_name Obstacle

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
