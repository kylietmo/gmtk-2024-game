extends PlatformRow

@onready var left_platform: Obstacle = $LeftPlatform
@onready var right_platform: Obstacle = $RightPlatform

const GAP_WIDTH_SCALAR = .15

# TODO: consider randomized height
func _ready():	
	var platform_width = (1.0 - GAP_WIDTH_SCALAR) / 2 * Globals.IN_BOUNDS_WIDTH
	left_platform.initialize_sprite(platform_width)
	right_platform.initialize_sprite(platform_width)
	var sprite : Sprite2D = left_platform.find_child("Sprite2D")
	var platform_sprite_width = sprite.texture.get_size().x
	
	left_platform.position.x = Globals.LEFT_BARRIER_X + platform_width / 2
	right_platform.position.x = Globals.RIGHT_BARRIER_X - platform_width / 2

	left_platform.scale.x = platform_width / platform_sprite_width
	right_platform.scale.x = platform_width / platform_sprite_width
