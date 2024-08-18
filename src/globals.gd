extends Node2D
signal score_changed

@export var score: int = 0 :
	get:
		return score
	set(value):
		score = value
		emit_signal("score_changed", value)
 
var SCREEN_WIDTH
var SCREEN_HEIGHT
var BARRIER_OFFSET
var IN_BOUNDS_WIDTH
var IN_BOUNDS_HEIGHT
var PLAYER_START_Y
var LEFT_BARRIER_X
var RIGHT_BARRIER_X
var LARGE_SIZE_SCALE
var MEDIUM_SIZE_SCALE
var SMALL_SIZE_SCALE

func _ready():
	SCREEN_WIDTH = get_window().size.x
	SCREEN_HEIGHT = get_window().size.y
	BARRIER_OFFSET = SCREEN_WIDTH / 16
	IN_BOUNDS_WIDTH = SCREEN_WIDTH - 2 * BARRIER_OFFSET
	IN_BOUNDS_HEIGHT = SCREEN_HEIGHT
	PLAYER_START_Y = -IN_BOUNDS_HEIGHT / 4
	LEFT_BARRIER_X = -IN_BOUNDS_WIDTH/2
	RIGHT_BARRIER_X = IN_BOUNDS_WIDTH/2
	LARGE_SIZE_SCALE = 3 * IN_BOUNDS_WIDTH / 1980
	MEDIUM_SIZE_SCALE = 1.5 * IN_BOUNDS_WIDTH / 1980
	SMALL_SIZE_SCALE = 0.5 * IN_BOUNDS_WIDTH / 1980
	
func save_high_score(score: int):
	var high_score_file = FileAccess.open("user://high_score.dat", FileAccess.WRITE)
	high_score_file.store_16(score)

func load_high_score():
	var high_score_file = FileAccess.open("user://high_score.dat", FileAccess.READ)
	if not high_score_file:
		return -1
		
	return high_score_file.get_16()
