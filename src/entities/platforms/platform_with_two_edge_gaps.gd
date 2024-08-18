extends PlatformRow

@onready var platform: Obstacle = $Platform

const GAP_WIDTH_SCALAR = .15

# TODO: consider randomized height
func _ready():
	var gap_width = Globals.IN_BOUNDS_WIDTH * GAP_WIDTH_SCALAR
	
	var platform_width = (Globals.IN_BOUNDS_WIDTH - (2 * gap_width))
	
	var sprite : Sprite2D = platform.find_child("Sprite2D")
	var platform_sprite_width = sprite.texture.get_size().x
	var platform_sprite_height = sprite.texture.get_size().y
	
	platform.position.x = Globals.LEFT_BARRIER_X + platform_width / 2 + gap_width

	platform.scale.x = platform_width / platform_sprite_width
