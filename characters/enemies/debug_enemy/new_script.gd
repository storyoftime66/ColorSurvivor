extends SoftBody2D


@onready var player := PlayerManager.player
var bodies : Array[PhysicsBody2D]

func _ready():
	var rigid_bodies = get_rigid_bodies()
	for rigid_body in rigid_bodies:
		bodies.append(rigid_body.rigidbody)
	for body in bodies:
		body.linear_damp = 3

func _process(delta):
	var direction = (player.position - global_position).normalized()
	var force = direction * 300
	constant_force = force
