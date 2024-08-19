extends CharacterBody2D
class_name Obstacle
signal broke_platform

@export var DESPAWN_TIME = 1.0
@export var texture : Texture

@onready var sprite : Sprite2D = $Sprite2D
@onready var collider: CollisionShape2D = $PillCollider

func initialize_sprite():
	if (is_instance_valid(sprite)):
		sprite.texture = texture
		collider.scale.x = sprite.texture.get_width() / collider.shape.get_rect().size.x
		
		# Divide by 2 to account for the pill shape not overflowing the UFOs for now
		collider.scale.y = sprite.texture.get_height() / collider.shape.get_rect().size.y / 2

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# only free if exiting from the top of the screen
	# TODO: can we do this without the parent?
	if get_parent().position.y < 0:
		$DespawnTimer.start(DESPAWN_TIME)


func _on_timer_timeout() -> void:
	queue_free.call_deferred()
