extends Control

@onready var line_2d: Line2D = $Line2D

var origin = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(get_local_mouse_position())
	line_2d.remove_point(0)
	line_2d.remove_point(1)
	line_2d.add_point(get_local_mouse_position())
	line_2d.add_point(origin)
