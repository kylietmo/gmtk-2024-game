extends PlatformRow

@onready var platform: Obstacle = $Platform

var platform_speed = 0.0
var platform_direction = 1
var platform_width = 0.0

func _ready():
	platform_width = Globals.IN_BOUNDS_WIDTH / 2
	platform_speed = platform_width / 50
	
	platform.initialize_sprite(platform_width)
	
	var rand = randf()
	if rand < .5:
		platform_direction = 1
		platform.position.x = Globals.LEFT_BARRIER_X + platform_width / 2
	else:
		platform_direction = -1
		platform.position.x = Globals.RIGHT_BARRIER_X - platform_width / 2

func _physics_process(_delta: float) -> void:
	if not platform:
		return
	if platform.position.x >= Globals.RIGHT_BARRIER_X - platform_width / 2:
		platform_direction = -1
	elif platform.position.x <= Globals.LEFT_BARRIER_X + platform_width / 2:
		platform_direction = 1
	
	platform.position.x += platform_speed * platform_direction
