extends StaticBody2D

func _ready() -> void:
	var sprite_size = $Sprite2D.texture.get_size().y
	var scale = Globals.IN_BOUNDS_HEIGHT / sprite_size
	
	$Sprite2D.scale.x = scale
	$CollisionShape2D.scale.y = scale
