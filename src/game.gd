extends Node

@export var SPEED = -700.0

@export var MIN_GAP_SIZE = 50
@export var MAX_GAP_SIZE = 100
@export var MIN_NUM_GAPS = 1
@export var MAX_NUM_GAPS = 4
@export var MIN_OBSTACLE_WIDTH = 200
@export var MIN_OBSTACLE_HEIGHT = 50
@export var MAX_OBSTACLE_HEIGHT = 200
@export var PROBABILITY_OF_GAP = 0.3
@onready var player : Player = %Player

var obstacles : Array[CharacterBody2D] = []
var obstacle_scene = preload("res://entities/obstacle/obstacle.tscn")
var breakable_obstacle_scene = preload("res://entities/obstacle/breakable_obstacle/breakable_obstacle.tscn")

const BREAKABLE_OBSTACLE_SPAWN_PROBABILITY = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.score = 0
	adjust_barriers()
	spawn_barrier_with_gaps()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match player.current_size:
		player.sizes.SMALL:
			SPEED = -1100
		player.sizes.MEDIUM:
			SPEED = -700
		player.sizes.LARGE:
			SPEED = -300
	
	# Update all existing obstacles to be moving up. 
	# TODO: If/when we change the direction of the level we'd need
	# to make this configurable per current direction.
	for o in obstacles:
		if is_instance_valid(o):
			o.position.y += delta * SPEED

func spawn_barrier_with_gaps() -> void:
	var viewport = get_viewport()
	var viewport_width = viewport.size.x
	var viewport_height = viewport.size.y
	var in_bounds_width = viewport_width - 2 * Globals.BARRIER_OFFSET
	var bounds_center_pos_x =  in_bounds_width/2

	var start_of_platform_x = -in_bounds_width/2
	var x = start_of_platform_x
	
	var is_gap_at_start = randi_range(0, 10) % 2 == 0
	if (is_gap_at_start):
		var start_platform : Obstacle = obstacle_scene.instantiate()
		var start_platform_size = 5
		
		start_platform.position.x = start_of_platform_x + (start_platform_size / 2)
		start_platform.position.y = viewport_height
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
			platform.position.y = viewport_height
			var sprite : Sprite2D = platform.find_child("Sprite2D")
			var platform_sprite_width = sprite.texture.get_size().x
			var platform_sprite_height = sprite.texture.get_size().y

			platform.scale.x = platform_width / platform_sprite_width
			platform.scale.y = platform_height / platform_sprite_height

			obstacles.append(platform)
			add_child(platform)
			break
		if (is_start_of_gap):
			print ("-------------")
			print ("STARTING GAP")
			print ("X: ", x)
			var platform : Obstacle = obstacle_scene.instantiate()
			var platform_width = x - start_of_platform_x
			var platform_height = randi_range(MIN_OBSTACLE_HEIGHT, MAX_OBSTACLE_HEIGHT)

			if (platform_width < MIN_OBSTACLE_WIDTH):
				x+= 1
				continue
			
			print ("Platform width: ", platform_width)
			platform.position.x = start_of_platform_x + (platform_width / 2)
			platform.position.y = viewport_height
			print ("Platform x position: ", platform.position.x)
			 #TODO: add variable height
			var sprite : Sprite2D = platform.find_child("Sprite2D")
			var platform_sprite_width = sprite.texture.get_size().x
			var platform_sprite_height = sprite.texture.get_size().y

			platform.scale.x = platform_width / platform_sprite_width
			platform.scale.y = platform_height / platform_sprite_height

			var gap_width = randi_range(MIN_GAP_SIZE, MAX_GAP_SIZE)
			print("Gap width: ", gap_width)
			start_of_platform_x = x + gap_width
			x = start_of_platform_x
			obstacles.append(platform)
			add_child(platform)
		else:
			x+= 1


func spawn_breakable_obstacle() -> void:
	var platform : BreakableObstacle = breakable_obstacle_scene.instantiate()
	
	var platform_width = get_viewport().size.x - 2*Globals.BARRIER_OFFSET
	var platform_height = randi_range(100, 200)

	platform.position.y = get_viewport().size.y
	
	var sprite : Sprite2D = platform.find_child("Sprite2D")
	var platform_sprite_width = sprite.texture.get_size().x
	var platform_sprite_height = sprite.texture.get_size().y

	platform.scale.x = platform_width / platform_sprite_width
	platform.scale.y = platform_height / platform_sprite_height
	
	obstacles.append(platform)
	add_child(platform)

func adjust_barriers() -> void:
	var viewport_width = get_viewport().size.x
	$Barriers/LeftWall.position.x = viewport_width / 2 * -1 + Globals.BARRIER_OFFSET
	$Barriers/RightWall.position.x = viewport_width / 2 - Globals.BARRIER_OFFSET
	
func _on_child_exiting_tree(node: Node) -> void:
	if node is Obstacle:
		obstacles.erase(node)

func _on_spawn_threshold_area_body_entered(body: Node2D) -> void:
	var rand = randf()
	if body is Obstacle:
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
