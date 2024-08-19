extends CPUParticles2D

var GRAVITY = Vector2(0, Globals.IN_BOUNDS_HEIGHT)
var DIRECTION = Vector2(0, 1)
var INITIAL_VELOCITY = Globals.IN_BOUNDS_WIDTH / 2
var AMOUNT = 2000
var SPREAD = 100
var LIFETIME = 0.5
var SPEED_SCALE = 5
var SCALE_MIN = 1
var SCALE_MAX = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = false
	one_shot = true
	gravity = GRAVITY
	direction = DIRECTION
	initial_velocity_max = INITIAL_VELOCITY
	amount = AMOUNT
	spread = SPREAD
	lifetime = LIFETIME
	speed_scale = SPEED_SCALE
	scale_amount_min = SCALE_MIN
	scale_amount_max = SCALE_MAX
