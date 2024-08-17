extends Label

const SCORE_LABEL_OFFSET = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = -Globals.IN_BOUNDS_HEIGHT/2 + SCORE_LABEL_OFFSET
	Globals.connect("score_changed", _on_score_changed)
	
func _on_score_changed(value: int) -> void:
	text = "Score: " + str(value)
