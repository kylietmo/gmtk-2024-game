extends Node2D

@export var MIN_SECS_BETWEEN_SPAWNS = 0.5
@export var MAX_SECS_BETWEEN_SPAWNS = 0.8
@export var SPEED = -500.0
@onready var player = $Player

const MIN_GAP_SIZE = 250
const MAX_GAP_SIZE = 400

var time_until_next_spawn = MIN_SECS_BETWEEN_SPAWNS
var curr_time_between_spawns = 0.0
var obstacles : Array[CharacterBody2D] = []
var obstacle_scene = preload("res://entities/obstacle/obstacle.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.position.y = get_viewport().size.y * -0.25
	adjust_barriers()
	spawn_double_platform()
	determine_time_until_next_obstacle_spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	curr_time_between_spawns += delta
	
	# Update all existing obstacles to be moving up. 
	# TODO: If/when we change the direction of the level we'd need
	# to make this configurable per current direction.
	for o in obstacles:
		if is_instance_valid(o):
			o.position.y += delta * SPEED

	# Check to see if it's time to spawn a new platform. 
	if curr_time_between_spawns >= time_until_next_spawn:
		curr_time_between_spawns = 0.0
		spawn_double_platform()
		determine_time_until_next_obstacle_spawn()

# TODO: account for multiple shapes and variable number of gaps
func spawn_double_platform() -> void:
	var left_platform : Obstacle = obstacle_scene.instantiate()
	var right_platform : Obstacle = obstacle_scene.instantiate()
	
	var viewport = get_viewport()
	var viewport_width = viewport.size.x
	var viewport_height = viewport.size.y
	var in_bounds_width = viewport_width - 2 * Globals.BARRIER_OFFSET
	
	var gap_width = randi_range(MIN_GAP_SIZE, MAX_GAP_SIZE)
	
	var left_platform_width = randi_range(0, in_bounds_width - gap_width)
	var right_platform_width = in_bounds_width - left_platform_width - gap_width

	var sprite : Sprite2D = left_platform.find_child("Sprite2D")
	var platform_sprite_width = sprite.texture.get_size().x

	left_platform.scale.x = left_platform_width / platform_sprite_width
	right_platform.scale.x = right_platform_width / platform_sprite_width
	
	left_platform.position.x = 0 - (in_bounds_width / 2) + (left_platform_width / 2)
	right_platform.position.x = (in_bounds_width / 2) - (right_platform_width / 2)
	
	left_platform.position.y = viewport_height
	right_platform.position.y = viewport_height
	
	obstacles.append(left_platform)
	obstacles.append(right_platform)
	add_child(left_platform)
	add_child(right_platform)

func determine_time_until_next_obstacle_spawn() -> void:
	var rand = randf_range(MIN_SECS_BETWEEN_SPAWNS, MAX_SECS_BETWEEN_SPAWNS)
	time_until_next_spawn = rand
	
func adjust_barriers() -> void:
	var viewport_width = get_viewport().size.x
	$Barriers/LeftWall.position.x = viewport_width / 2 * -1 + Globals.BARRIER_OFFSET
	$Barriers/RightWall.position.x = viewport_width / 2 - Globals.BARRIER_OFFSET
	
func _on_child_exiting_tree(node: Node) -> void:
	if node is Obstacle:
		obstacles.erase(node)
