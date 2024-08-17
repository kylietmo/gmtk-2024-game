extends Node2D

@export var SPEED = -700.0

@export var MIN_GAP_SIZE = 100
@export var MAX_GAP_SIZE = 400
@export var MIN_NUM_GAPS = 1
@export var MAX_NUM_GAPS = 4

@onready var player : Player = $Player

var obstacles : Array[CharacterBody2D] = []
var obstacle_scene = preload("res://entities/obstacle/obstacle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	while x <= in_bounds_width/2:
		# TODO: need a min platform size
		var is_start_of_gap = randi_range(0, 100) <= 3
		var at_end_platform =  (in_bounds_width/2  - x) < 200
		if (at_end_platform):
			var platform : Obstacle = obstacle_scene.instantiate()
			var platform_width = in_bounds_width/2 - start_of_platform_x
			var platform_height = randi_range(100, 200)
			
			platform.position.x = start_of_platform_x + (platform_width / 2)
			platform.position.y = viewport_height
			 #TODO: add variable height
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
			var platform_height = randi_range(50, 150)

			if (platform_width < 200):
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

			var gap_width = randi_range(100, 400)
			print("Gap width: ", gap_width)
			start_of_platform_x = x + gap_width
			x = start_of_platform_x
			obstacles.append(platform)
			add_child(platform)
		else:
			x+= 1

func adjust_barriers() -> void:
	var viewport_width = get_viewport().size.x
	$Barriers/LeftWall.position.x = viewport_width / 2 * -1 + Globals.BARRIER_OFFSET
	$Barriers/RightWall.position.x = viewport_width / 2 - Globals.BARRIER_OFFSET
	
func _on_child_exiting_tree(node: Node) -> void:
	if node is Obstacle:
		obstacles.erase(node)

func _on_spawn_threshold_area_body_entered(body: Node2D) -> void:
	if body is Obstacle:
		spawn_barrier_with_gaps()
