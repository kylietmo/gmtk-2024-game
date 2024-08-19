extends PlatformRow

@onready var left_platform: Obstacle = $LeftPlatform
@onready var middle_platform: Obstacle = $MiddlePlatform
@onready var right_platform: Obstacle = $RightPlatform

const GAP_WIDTH_SCALAR = .12
const MAX_ROTATION_DEGREES = 20.0

# TODO: consider randomized height
func _ready():
	var gap_width = Globals.IN_BOUNDS_WIDTH * GAP_WIDTH_SCALAR
	var platform_width = (1 - (GAP_WIDTH_SCALAR * 2)) /3  * Globals.IN_BOUNDS_WIDTH
	
	left_platform.initialize_sprite(platform_width)
	middle_platform.initialize_sprite(platform_width)
	right_platform.initialize_sprite(platform_width)

	left_platform.position.x = Globals.LEFT_BARRIER_X + platform_width / 2
	right_platform.position.x = Globals.RIGHT_BARRIER_X - platform_width / 2
	middle_platform.position.x = Globals.LEFT_BARRIER_X + platform_width + gap_width + platform_width / 2

	left_platform.rotation_degrees = randf_range(-MAX_ROTATION_DEGREES, MAX_ROTATION_DEGREES)
	right_platform.rotation_degrees = randf_range(-MAX_ROTATION_DEGREES, MAX_ROTATION_DEGREES)
	middle_platform.rotation_degrees = randf_range(-MAX_ROTATION_DEGREES, MAX_ROTATION_DEGREES)
