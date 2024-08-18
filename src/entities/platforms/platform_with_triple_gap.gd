extends PlatformRow

@onready var left_platform: Obstacle = $LeftPlatform
@onready var right_platform: Obstacle = $RightPlatform

const GAP_WIDTH_SCALAR = .12
const MAX_ROTATION_DEGREES = 20.0

# TODO: consider randomized height
func _ready():
	var gap_width = Globals.IN_BOUNDS_WIDTH * GAP_WIDTH_SCALAR
	
	var platform_width = (Globals.IN_BOUNDS_WIDTH - (3 * gap_width)) / 2
	
	var sprite : Sprite2D = left_platform.find_child("Sprite2D")
	var platform_sprite_width = sprite.texture.get_size().x
	
	left_platform.position.x = Globals.LEFT_BARRIER_X + platform_width / 2 + gap_width
	right_platform.position.x = Globals.RIGHT_BARRIER_X - platform_width / 2 - gap_width

	left_platform.scale.x = platform_width / platform_sprite_width
	right_platform.scale.x = platform_width / platform_sprite_width
	
	left_platform.rotation_degrees = randf_range(-MAX_ROTATION_DEGREES, MAX_ROTATION_DEGREES)
	right_platform.rotation_degrees = randf_range(-MAX_ROTATION_DEGREES, MAX_ROTATION_DEGREES)
