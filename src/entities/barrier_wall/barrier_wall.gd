extends StaticBody2D
class_name BarrierWall

func _ready() -> void:
	var sprite_size = $Sprite2D.texture.get_size().y
	var barrier_scale = Globals.IN_BOUNDS_HEIGHT / sprite_size
	
	$Sprite2D.scale.x = barrier_scale
	$CollisionShape2D.scale.y = barrier_scale
