extends RigidBody2D


var damage: float = 5
var speed: float = 1000


# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector2(speed, 0).rotated(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MagicMissle_body_entered(body):
	pass # Replace with function body.
