extends Node2D
signal score_changed

@export var score: int = 0 :
	get:
		return score
	set(value):
		score = value
		score_changed.emit(value)
 
var SCREEN_WIDTH
var SCREEN_HEIGHT
var BARRIER_OFFSET
var IN_BOUNDS_WIDTH
var IN_BOUNDS_HEIGHT
var PLAYER_START_Y
var LEFT_BARRIER_X
var RIGHT_BARRIER_X
var MASSIVE_SIZE_SCALE
var LARGE_SIZE_SCALE
var MEDIUM_SIZE_SCALE
var SMALL_SIZE_SCALE
var SMALL_PLATFORM_TEXTURE = preload("res://sprites/Small planet.png")
var MEDIUM_PLATFORM_TEXTURE = preload("res://sprites/Mediumplanet.png")
var LARGE_PLATFORM_TEXTURE = preload("res://sprites/Big planet.png")

func _ready():
	SCREEN_WIDTH = get_viewport_rect().size.x
	SCREEN_HEIGHT = get_viewport_rect().size.y
	BARRIER_OFFSET = SCREEN_WIDTH / 16
	IN_BOUNDS_WIDTH = SCREEN_WIDTH - 2 * BARRIER_OFFSET
	IN_BOUNDS_HEIGHT = SCREEN_HEIGHT
	PLAYER_START_Y = -IN_BOUNDS_HEIGHT / 4
	LEFT_BARRIER_X = -IN_BOUNDS_WIDTH/2
	RIGHT_BARRIER_X = IN_BOUNDS_WIDTH/2
	MASSIVE_SIZE_SCALE = 5 * IN_BOUNDS_WIDTH / 1980
	LARGE_SIZE_SCALE = 3 * IN_BOUNDS_WIDTH / 1980
	MEDIUM_SIZE_SCALE = 1.5 * IN_BOUNDS_WIDTH / 1980
	SMALL_SIZE_SCALE = 0.5 * IN_BOUNDS_WIDTH / 1980
	
func save_high_score(high_score: int):
	var high_score_file = FileAccess.open("user://high_score.dat", FileAccess.WRITE)
	high_score_file.store_16(high_score)

func load_high_score():
	var high_score_file = FileAccess.open("user://high_score.dat", FileAccess.READ)
	if not high_score_file:
		return -1
		
	return high_score_file.get_16()
