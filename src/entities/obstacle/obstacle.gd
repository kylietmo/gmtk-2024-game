extends CharacterBody2D
class_name Obstacle
signal broke_platform

@export var DESPAWN_TIME = 1.0

@export var texture : Texture

func initialize_sprite():
	var sprite = get_node("Sprite2D")
	if (is_instance_valid(sprite)):	
		sprite.texture = texture

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# only free if exiting from the top of the screen
	# TODO: can we do this without the parent?
	if get_parent().position.y < 0:
		$DespawnTimer.start(DESPAWN_TIME)


func _on_timer_timeout() -> void:
	queue_free.call_deferred()
