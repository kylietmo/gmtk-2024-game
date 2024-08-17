extends Area2D

@onready var player : Player = %Player

func _ready() -> void:	
	position.x = Globals.LEFT_BARRIER_X
	position.y = player.position.y
