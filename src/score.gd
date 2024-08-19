extends Label

var X_OFFSET = Globals.IN_BOUNDS_WIDTH / 20
var Y_OFFSET = Globals.IN_BOUNDS_HEIGHT / 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = Globals.LEFT_BARRIER_X + X_OFFSET
	position.y = -Globals.IN_BOUNDS_HEIGHT/2 + Y_OFFSET
	Globals.connect("score_changed", _on_score_changed)
	
func _on_score_changed(value: int) -> void:
	text = "Score: " + str(value)
