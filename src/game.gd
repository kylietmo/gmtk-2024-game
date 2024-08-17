extends Node

@export var SPEED = -300.0

@export var MIN_GAP_SIZE = 100
@export var MAX_GAP_SIZE = 150
@export var MIN_NUM_GAPS = 1
@export var MAX_NUM_GAPS = 4
@export var MIN_OBSTACLE_WIDTH = 100
@export var MAX_OBSTACLE_WIDTH = 500
@export var MIN_OBSTACLE_HEIGHT = 50
@export var MAX_OBSTACLE_HEIGHT = 150
@export var PROBABILITY_OF_GAP = 0.3
@export var MIN_SECS_BETWEEN_SPAWNS = 1.0
@export var MAX_SECS_BETWEEN_SPAWNS = 2.0

@onready var player : Player = %Player

var obstacles : Array[CharacterBody2D] = []
var obstacle_scene = preload("res://entities/obstacle/obstacle.tscn")
var breakable_obstacle_scene = preload("res://entities/obstacle/breakable_obstacle/breakable_obstacle.tscn")

const BREAKABLE_OBSTACLE_SPAWN_PROBABILITY = 0.25
const OBSTACLE_SPAWN_OFFSET = 200

var time_until_next_spawn = MIN_SECS_BETWEEN_SPAWNS
var curr_time_between_spawns = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.score = 0
	spawn_barrier_with_gaps()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	curr_time_between_spawns += delta
	
	match player.current_size:
		player.sizes.SMALL:
			SPEED = -1200
		player.sizes.MEDIUM:
			SPEED = -300
		player.sizes.LARGE:
			SPEED = -200
	
	# Update all existing obstacles to be moving up. 
	# TODO: If/when we change the direction of the level we'd need
	# to make this configurable per current direction.
	for o in obstacles:
		if is_instance_valid(o):
			o.position.y += delta * SPEED

	# Check to see if it's time to spawn a new platform. 
	if curr_time_between_spawns >= time_until_next_spawn:
		curr_time_between_spawns = 0.0
		spawn_obstacle()
		determine_time_until_next_obstacle_spawn()

func determine_time_until_next_obstacle_spawn() -> void:
	var rand = randf_range(MIN_SECS_BETWEEN_SPAWNS, MAX_SECS_BETWEEN_SPAWNS)
	time_until_next_spawn = rand

func spawn_barrier_with_gaps() -> void:
	print ("_______________")
	var in_bounds_width = Globals.IN_BOUNDS_WIDTH

	var x = Globals.LEFT_BARRIER_X
	print("left barrier x: ", x)
	print("right barrier x: ", Globals.RIGHT_BARRIER_X)
	var is_gap_at_start = randf_range(0, 1) <= PROBABILITY_OF_GAP
	if is_gap_at_start:
		print("is gap at start!")
		var gap_width = randi_range(MIN_GAP_SIZE, MAX_GAP_SIZE)
		x = x + gap_width
		
	print ("starting x: ", x)
	while x <= Globals.RIGHT_BARRIER_X:
		print("---")
		# draw first platform
		print("drawing platform at: ", x)
		var platform : Obstacle = obstacle_scene.instantiate()
		var platform_width = randi_range(MIN_OBSTACLE_WIDTH, Globals.IN_BOUNDS_WIDTH - MIN_GAP_SIZE)
		print("platform_width: ", platform_width)
		var platform_height = randi_range(MIN_OBSTACLE_HEIGHT, MAX_OBSTACLE_HEIGHT)
		
		platform.position.x = x + (platform_width / 2)
		platform.position.y = Globals.RIGHT_BARRIER_X + OBSTACLE_SPAWN_OFFSET

		var sprite : Sprite2D = platform.find_child("Sprite2D")
		var platform_sprite_width = sprite.texture.get_size().x
		var platform_sprite_height = sprite.texture.get_size().y

		platform.scale.x = platform_width / platform_sprite_width
		platform.scale.y = platform_height / platform_sprite_height

		x = x + platform_width
		var distance_to_right_barrier = Globals.RIGHT_BARRIER_X - platform_width
		if (distance_to_right_barrier < MIN_GAP_SIZE):
			print("need to just continuee the platform")
			# We just need to extend this platform size
			platform_width += distance_to_right_barrier
			platform.position.x = x + (platform_width / 2)
			platform.scale.x = platform_width / platform_sprite_width

			obstacles.append(platform)
			add_child(platform)	
			return
		
		# draw gap after platform
		print("drawing gap after platform")
		var gap_width = randi_range(MIN_GAP_SIZE, MAX_GAP_SIZE)
		print("gap_width: ", gap_width)
		x = x + gap_width

func spawn_breakable_obstacle() -> void:
	var platform : BreakableObstacle = breakable_obstacle_scene.instantiate()
	
	var platform_width = Globals.IN_BOUNDS_WIDTH
	
	var platform_height = randi_range(100, 200)

	platform.position.y = Globals.IN_BOUNDS_HEIGHT / 2 + OBSTACLE_SPAWN_OFFSET
	
	var sprite : Sprite2D = platform.find_child("Sprite2D")
	var platform_sprite_width = sprite.texture.get_size().x
	var platform_sprite_height = sprite.texture.get_size().y

	platform.scale.x = platform_width / platform_sprite_width
	platform.scale.y = platform_height / platform_sprite_height
	
	obstacles.append(platform)
	add_child(platform)
	
func _on_child_exiting_tree(node: Node) -> void:
	if node is Obstacle:
		obstacles.erase(node)


func spawn_obstacle() -> void:
	var rand = randf()
	if rand <= BREAKABLE_OBSTACLE_SPAWN_PROBABILITY:
		spawn_breakable_obstacle()
	else:
		spawn_barrier_with_gaps()

func _on_score_area_body_exited(body: Node2D) -> void:
	if body is Obstacle:
		increment_score()

func increment_score() -> void:
	Globals.score += 1
	$Score.text = "Score: " + str(Globals.score)
