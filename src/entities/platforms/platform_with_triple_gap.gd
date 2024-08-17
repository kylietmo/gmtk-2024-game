extends PlatformRow

@onready var left_platform: Obstacle = $LeftPlatform
@onready var right_platform: Obstacle = $RightPlatform

const GAP_WIDTH_SCALAR = .11

# TODO: consider randomized height
func _ready():
	var gap_width = Globals.IN_BOUNDS_WIDTH * GAP_WIDTH_SCALAR
	
	var platform_width = (Globals.IN_BOUNDS_WIDTH - (3 * gap_width)) / 2
	
	var sprite : Sprite2D = left_platform.find_child("Sprite2D")
	var platform_sprite_width = sprite.texture.get_size().x
	var platform_sprite_height = sprite.texture.get_size().y
	
	left_platform.position.x = Globals.LEFT_BARRIER_X + platform_width / 2 + gap_width
	right_platform.position.x = Globals.RIGHT_BARRIER_X - platform_width / 2 - gap_width

	left_platform.scale.x = platform_width / platform_sprite_width
	right_platform.scale.x = platform_width / platform_sprite_width
