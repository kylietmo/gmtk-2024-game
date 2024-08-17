extends PlatformRow

@onready var left_platform: Obstacle = $LeftPlatform
@onready var middle_platform: Obstacle = $MiddlePlatform
@onready var right_platform: Obstacle = $RightPlatform

const GAP_WIDTH_SCALAR = .10

# TODO: consider randomized height
func _ready():
	var gap_width = Globals.IN_BOUNDS_WIDTH * GAP_WIDTH_SCALAR
	var platform_width = (1 - (GAP_WIDTH_SCALAR * 2)) /3  * Globals.IN_BOUNDS_WIDTH
	
	var sprite : Sprite2D = left_platform.find_child("Sprite2D")
	var platform_sprite_width = sprite.texture.get_size().x
	var platform_sprite_height = sprite.texture.get_size().y
	
	left_platform.position.x = Globals.LEFT_BARRIER_X + platform_width / 2
	right_platform.position.x = Globals.RIGHT_BARRIER_X - platform_width / 2
	middle_platform.position.x = Globals.LEFT_BARRIER_X + platform_width + gap_width + platform_width / 2

	left_platform.scale.x = platform_width / platform_sprite_width
	right_platform.scale.x = platform_width / platform_sprite_width
	middle_platform.scale.x = platform_width / platform_sprite_width
