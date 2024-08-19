extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity.x = 0
	gravity.y = -Globals.IN_BOUNDS_HEIGHT / 4
	initial_velocity_max = Globals.IN_BOUNDS_WIDTH / 10
