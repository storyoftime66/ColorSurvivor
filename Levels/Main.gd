extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	print(rad2deg(Vector2(1, 0).angle_to(Vector2(1, 1))))
	print(rad2deg(Vector2(0, 0).angle_to_point(Vector2(1, 1))))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
