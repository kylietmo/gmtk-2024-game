extends PlatformRow

@onready var left_platform: Obstacle = $LeftPlatform

const GAP_WIDTH_SCALAR = .2
const MAX_ROTATION_DEGREES = 2.0


# TODO: consider randomized height
func _ready():
	var gap_width = Globals.IN_BOUNDS_WIDTH * GAP_WIDTH_SCALAR
	
	var platform_width = Globals.IN_BOUNDS_WIDTH - gap_width
	
	left_platform.initialize_sprite(platform_width)
	
	left_platform.position.x = Globals.LEFT_BARRIER_X + platform_width / 2	
	left_platform.rotation_degrees = randf_range(-MAX_ROTATION_DEGREES, MAX_ROTATION_DEGREES)
