extends StaticBody2D
class_name BarrierWall

func _ready() -> void:
	var barrier_scale = Globals.IN_BOUNDS_HEIGHT	
	$CollisionShape2D.scale.y = barrier_scale
