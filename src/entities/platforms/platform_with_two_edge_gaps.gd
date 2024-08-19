extends PlatformRow

@onready var platform: Obstacle = $Platform

const GAP_WIDTH_SCALAR = .15
const MAX_ROTATION_DEGREES = 20.0

# TODO: consider randomized height
func _ready():
	var gap_width = Globals.IN_BOUNDS_WIDTH * GAP_WIDTH_SCALAR
	
	var platform_width = (Globals.IN_BOUNDS_WIDTH - (2 * gap_width))
	platform.initialize_sprite(platform_width)
	var sprite : Sprite2D = platform.find_child("Sprite2D")
	var platform_sprite_width = sprite.texture.get_size().x
	
	platform.position.x = Globals.LEFT_BARRIER_X + platform_width / 2 + gap_width
	
	platform.rotation_degrees = randf_range(-MAX_ROTATION_DEGREES, MAX_ROTATION_DEGREES)
