extends Node2D

@export var SPEED = -500.0
@onready var player : Player = $Player

const MIN_GAP_SIZE = 100
const MAX_GAP_SIZE = 400

var obstacles : Array[CharacterBody2D] = []
var obstacle_scene = preload("res://entities/obstacle/obstacle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	adjust_barriers()
	spawn_double_platform()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# TODO: tweak spawn rate based on sizes
	match player.current_size:
		player.sizes.SMALL:
			SPEED = -700
		player.sizes.MEDIUM:
			SPEED = -500
		player.sizes.LARGE:
			SPEED = -300
	
	# Update all existing obstacles to be moving up. 
	# TODO: If/when we change the direction of the level we'd need
	# to make this configurable per current direction.
	for o in obstacles:
		if is_instance_valid(o):
			o.position.y += delta * SPEED

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

func adjust_barriers() -> void:
	var viewport_width = get_viewport().size.x
	$Barriers/LeftWall.position.x = viewport_width / 2 * -1 + Globals.BARRIER_OFFSET
	$Barriers/RightWall.position.x = viewport_width / 2 - Globals.BARRIER_OFFSET
	
func _on_child_exiting_tree(node: Node) -> void:
	if node is Obstacle:
		obstacles.erase(node)

func _on_spawn_threshold_area_body_entered(body: Node2D) -> void:
	if body is Obstacle:
		spawn_double_platform()
