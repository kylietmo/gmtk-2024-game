extends PlatformRow

@onready var left_platform: Obstacle = $LeftPlatform

const GAP_WIDTH_SCALAR = .15
const MAX_ROTATION_DEGREES = 5.0

# TODO: consider randomized height
func _ready():
	var gap_width = Globals.IN_BOUNDS_WIDTH * GAP_WIDTH_SCALAR
	
	var platform_width = Globals.IN_BOUNDS_WIDTH - gap_width
	
	var sprite : Sprite2D = left_platform.find_child("Sprite2D")
	var platform_sprite_width = sprite.texture.get_size().x
	var platform_sprite_height = sprite.texture.get_size().y
	
	left_platform.position.x = Globals.LEFT_BARRIER_X + platform_width / 2

	left_platform.scale.x = platform_width / platform_sprite_width
	
	left_platform.rotation_degrees = randf_range(-MAX_ROTATION_DEGREES, MAX_ROTATION_DEGREES)
