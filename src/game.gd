extends Node2D

@export var MIN_SECS_BETWEEN_SPAWNS = 0.5
@export var MAX_SECS_BETWEEN_SPAWNS = 2.0
@export var SPEED = -500.0
@onready var player = $Player

var time_until_next_spawn = MIN_SECS_BETWEEN_SPAWNS
var curr_time_between_spawns = 0.0
var obstacles : Array[CharacterBody2D]= []
var double_platform_scene = preload("res://entities/double_platform/double_platform.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.position.y = get_viewport().size.y * -0.25
	spawn_obstacle()
	determine_time_until_next_obstacle_spawn()
	adjust_barriers()

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
		spawn_obstacle()
		determine_time_until_next_obstacle_spawn()
	
func spawn_obstacle() -> void:
	var obstacle : Node2D = double_platform_scene.instantiate()
	var viewport_rect = get_viewport_rect()
	var viewport_rect_x = viewport_rect.size.x
	obstacle.position.x = randf_range(-viewport_rect_x, viewport_rect_x)
	obstacle.position.y = viewport_rect.end.y
	obstacles.append(obstacle)
	add_child(obstacle)

func determine_time_until_next_obstacle_spawn() -> void:
	var rand = randf_range(MIN_SECS_BETWEEN_SPAWNS, MAX_SECS_BETWEEN_SPAWNS)
	time_until_next_spawn = rand
	
func adjust_barriers() -> void:
	var viewport_width = get_viewport().size.x
	$Barriers/LeftWall.position.x = viewport_width / -2 + 100
	$Barriers/RightWall.position.x = viewport_width / 2 - 100
	
func _on_child_exiting_tree(node: Node) -> void:
	if node is DoublePlatform:
		obstacles.erase(node)
