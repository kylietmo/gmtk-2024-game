extends CharacterBody2D
class_name Obstacle
signal broke_platform

@export var DESPAWN_TIME = 1.0
@export var texture : Texture

func initialize_sprite(desired_width : float):
	var sprite : Sprite2D = $Sprite2D
	var collider: CollisionShape2D = $PillCollider

	if (is_instance_valid(sprite)):
		sprite.texture = texture
		collider.scale.x = sprite.texture.get_width() / collider.shape.get_rect().size.x
		
		# TODO: save our souls
		collider.position.y -= sprite.texture.get_height() / 8
		collider.scale.y = sprite.texture.get_height() / collider.shape.get_rect().size.y / 6
		
		var sprite_width = sprite.texture.get_size().x
		var sprite_height = sprite.texture.get_size().y
		var sprite_ratio  = sprite_width / sprite_height
		
		var desired_height = desired_width / sprite_ratio
		
		scale.x = desired_width / sprite_width
		scale.y = desired_height / sprite_height

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# only free if exiting from the top of the screen
	# TODO: can we do this without the parent?
	if get_parent().position.y < 0:
		$DespawnTimer.start(DESPAWN_TIME)


func _on_timer_timeout() -> void:
	queue_free.call_deferred()
