extends Node
signal score_changed

static var BARRIER_OFFSET = 100
static var SCREEN_WIDTH = 1920
static var IN_BOUNDS_WIDTH = SCREEN_WIDTH - 2 * BARRIER_OFFSET
static var IN_BOUNDS_HEIGHT = 1080
static var PLAYER_START_Y = -IN_BOUNDS_HEIGHT / 4
static var LEFT_BARRIER_X = -IN_BOUNDS_WIDTH/2
static var RIGHT_BARRIER_X = IN_BOUNDS_WIDTH/2

@export var score: int = 0 :
	get:
		return score
	set(value):
		score = value
		emit_signal("score_changed", value)
