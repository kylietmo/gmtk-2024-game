extends Node2D

@onready var left_wall: StaticBody2D = $LeftWall
@onready var right_wall: StaticBody2D = $RightWall

func _ready() -> void:
	left_wall.transform.origin.x = Globals.LEFT_BARRIER_X
	right_wall.transform.origin.x = Globals.RIGHT_BARRIER_X
	
	left_wall.transform.origin.y = 0
	right_wall.transform.origin.y = 0
