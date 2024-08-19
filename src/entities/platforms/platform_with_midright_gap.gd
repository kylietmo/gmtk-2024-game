extends PlatformRow

@onready var left_platform: Obstacle = $LeftPlatform
@onready var right_platform: Obstacle = $RightPlatform

const GAP_WIDTH_SCALAR = .15

# TODO: consider randomized height
func _ready():	
	var left_platform_width = (1.0 - GAP_WIDTH_SCALAR) / 2 * Globals.IN_BOUNDS_WIDTH + (Globals.IN_BOUNDS_WIDTH / 4)
	var right_platform_width = (1.0 - GAP_WIDTH_SCALAR) / 2 * Globals.IN_BOUNDS_WIDTH - (Globals.IN_BOUNDS_WIDTH / 4)
	left_platform.initialize_sprite(left_platform_width)
	right_platform.initialize_sprite(right_platform_width)

	left_platform.position.x = Globals.LEFT_BARRIER_X + left_platform_width / 2
	right_platform.position.x = Globals.RIGHT_BARRIER_X - right_platform_width / 2
