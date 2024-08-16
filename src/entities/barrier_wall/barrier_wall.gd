extends StaticBody2D

func _ready() -> void:
	var viewport_height = get_viewport().size.y
	
	var sprite_size = $Sprite2D.texture.get_size().y
	
	var scale = viewport_height / sprite_size
	
	$Sprite2D.scale.x = scale
