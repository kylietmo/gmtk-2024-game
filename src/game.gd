extends Node


@export var SPEED = - Globals.IN_BOUNDS_HEIGHT / 4
@export var MIN_NUM_GAPS = 1
@export var MAX_NUM_GAPS = 4
@export var MIN_OBSTACLE_WIDTH = Globals.IN_BOUNDS_WIDTH / 10
@export var MIN_OBSTACLE_HEIGHT = Globals.IN_BOUNDS_HEIGHT / 40
@export var MAX_OBSTACLE_HEIGHT = Globals.IN_BOUNDS_HEIGHT / 25
@export var PROBABILITY_OF_GAP = 0.3
@export var MIN_SECS_BETWEEN_SPAWNS = 1.0
@export var MAX_SECS_BETWEEN_SPAWNS = 2.0
@export var OBSTACLE_SPAWN_OFFSET = Globals.IN_BOUNDS_HEIGHT / 10
@export var BREAKABLE_OBSTACLE_SPAWN_PROBABILITY = 0.25

@onready var player : Player = %Player

var MIN_GAP_SIZE
var MAX_GAP_SIZE

var obstacles : Array[CharacterBody2D] = []
var obstacle_scene = preload("res://entities/obstacle/obstacle.tscn")
var breakable_obstacle_scene = preload("res://entities/obstacle/breakable_obstacle/breakable_obstacle.tscn")

var time_until_next_spawn = MIN_SECS_BETWEEN_SPAWNS
var curr_time_between_spawns = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_sprite : Sprite2D = player.find_child("Sprite2D")
	var player_sprite_x = player_sprite.texture.get_size().x
	MIN_GAP_SIZE = player_sprite_x * 0.5
	MAX_GAP_SIZE = player_sprite_x * 0.8
	print(MIN_GAP_SIZE)
	print(MAX_GAP_SIZE)

	Globals.score = 0
	spawn_barrier_with_gaps()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	curr_time_between_spawns += delta
	
	match player.current_size:
		player.sizes.SMALL:
			SPEED = -Globals.IN_BOUNDS_HEIGHT
		player.sizes.MEDIUM:
			SPEED = -Globals.IN_BOUNDS_HEIGHT / 4
		player.sizes.LARGE:
			SPEED = -Globals.IN_BOUNDS_HEIGHT / 5
	
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
	var in_bounds_width = Globals.IN_BOUNDS_WIDTH
	var bounds_center_pos_x =  in_bounds_width/2

	var start_of_platform_x = -in_bounds_width/2
	var x = start_of_platform_x
	
	var is_gap_at_start = randi_range(0, 10) % 2 == 0
	if (is_gap_at_start):
		var start_platform : Obstacle = obstacle_scene.instantiate()
		var start_platform_size = 5
		
		start_platform.position.x = start_of_platform_x + (start_platform_size / 2)
		start_platform.position.y = Globals.IN_BOUNDS_HEIGHT / 2 + OBSTACLE_SPAWN_OFFSET
		var sprite : Sprite2D = start_platform.find_child("Sprite2D")
		var platform_sprite_width = sprite.texture.get_size().x
		var platform_sprite_height = sprite.texture.get_size().y

		start_platform.scale.x = start_platform_size / platform_sprite_width
		start_platform.scale.y = start_platform_size / platform_sprite_height

		obstacles.append(start_platform)
		add_child(start_platform)
		var gap_width = randi_range(MIN_GAP_SIZE, MAX_GAP_SIZE)

		start_of_platform_x = x + gap_width
		x = start_of_platform_x

	while x <= in_bounds_width/2:
		var is_start_of_gap = randf_range(0, 1) <= PROBABILITY_OF_GAP
		var at_end_platform =  (in_bounds_width/2  - x) < MIN_OBSTACLE_WIDTH
		if (at_end_platform):
			var platform : Obstacle = obstacle_scene.instantiate()
			var platform_width = in_bounds_width/2 - start_of_platform_x
			var platform_height = randi_range(MIN_OBSTACLE_HEIGHT, MAX_OBSTACLE_HEIGHT)
			
			platform.position.x = start_of_platform_x + (platform_width / 2)
			platform.position.y = Globals.IN_BOUNDS_HEIGHT / 2 + OBSTACLE_SPAWN_OFFSET
			
			var sprite : Sprite2D = platform.find_child("Sprite2D")
			var platform_sprite_width = sprite.texture.get_size().x
			var platform_sprite_height = sprite.texture.get_size().y

			platform.scale.x = platform_width / platform_sprite_width
			platform.scale.y = platform_height / platform_sprite_height

			obstacles.append(platform)
			add_child(platform)
			break
		if (is_start_of_gap):
			var platform : Obstacle = obstacle_scene.instantiate()
			var platform_width = x - start_of_platform_x
			var platform_height = randi_range(MIN_OBSTACLE_HEIGHT, MAX_OBSTACLE_HEIGHT)

			if (platform_width < MIN_OBSTACLE_WIDTH):
				x+= 1
				continue
			
			platform.position.x = start_of_platform_x + (platform_width / 2)
			platform.position.y = Globals.IN_BOUNDS_HEIGHT / 2 + OBSTACLE_SPAWN_OFFSET

			# TODO: add variable height
			var sprite : Sprite2D = platform.find_child("Sprite2D")
			var platform_sprite_width = sprite.texture.get_size().x
			var platform_sprite_height = sprite.texture.get_size().y

			platform.scale.x = platform_width / platform_sprite_width
			platform.scale.y = platform_height / platform_sprite_height

			var gap_width = randi_range(MIN_GAP_SIZE, MAX_GAP_SIZE)

			start_of_platform_x = x + gap_width
			x = start_of_platform_x
			obstacles.append(platform)
			add_child(platform)
		else:
			x+= 1


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
