extends PlatformRow

@onready var platform: Obstacle = $Platform

var platform_speed = 0.0
var platform_direction = 1
var platform_width = 0.0

func _ready():
	platform_width = Globals.IN_BOUNDS_WIDTH / 3
	platform_speed = platform_width / 50
	
	var sprite : Sprite2D = platform.find_child("Sprite2D")
	var platform_sprite_width = sprite.texture.get_size().x
	var platform_sprite_height = sprite.texture.get_size().y
	
	var rand = randf()
	if rand < .5:
		platform_direction = 1
		platform.position.x = Globals.LEFT_BARRIER_X + platform_width / 2
	else:
		platform_direction = -1
		platform.position.x = Globals.RIGHT_BARRIER_X - platform_width / 2

	platform.scale.x = platform_width / platform_sprite_width

func _physics_process(delta: float) -> void:
	if not platform:
		return
	if platform.position.x >= Globals.RIGHT_BARRIER_X - platform_width / 2:
		platform_direction = -1
	elif platform.position.x <= Globals.LEFT_BARRIER_X + platform_width / 2:
		platform_direction = 1
	
	platform.position.x += platform_speed * platform_direction
