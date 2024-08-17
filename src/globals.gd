extends Node2D
signal score_changed

@export var score: int = 0 :
	get:
		return score
	set(value):
		score = value
		emit_signal("score_changed", value)
 
var SCREEN_WIDTH = 1920
var SCREEN_HEIGHT = 1080
var BARRIER_OFFSET = SCREEN_WIDTH / 16
var IN_BOUNDS_WIDTH = SCREEN_WIDTH - 2 * BARRIER_OFFSET
var IN_BOUNDS_HEIGHT = SCREEN_HEIGHT
var PLAYER_START_Y = -IN_BOUNDS_HEIGHT / 4
var LEFT_BARRIER_X = -IN_BOUNDS_WIDTH/2
var RIGHT_BARRIER_X = IN_BOUNDS_WIDTH/2

func _ready():
	SCREEN_WIDTH = get_window().size.x
	SCREEN_HEIGHT = get_window().size.y
	BARRIER_OFFSET = SCREEN_WIDTH / 16
	IN_BOUNDS_WIDTH = SCREEN_WIDTH - 2 * BARRIER_OFFSET
	IN_BOUNDS_HEIGHT = SCREEN_HEIGHT
	PLAYER_START_Y = -IN_BOUNDS_HEIGHT / 4
	LEFT_BARRIER_X = -IN_BOUNDS_WIDTH/2
	RIGHT_BARRIER_X = IN_BOUNDS_WIDTH/2
