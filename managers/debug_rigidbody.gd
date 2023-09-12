extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var apply_impulse = false
var speed_force := Vector2(0, 0)
var speed = 100.0
var count := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _physics_process(delta):
#	applied_force = (PlayerManager.player_position - global_position).normalized() * 500
#	pass

#func _integrate_forces(state: Physics2DDirectBodyState):
#	print(state.step)


func _on_RigidBody2D_input_event(viewport, event: InputEvent, shape_idx):
	print("clicked")
	
	if event.is_action_pressed("debug_click"):
		add_central_force(Vector2(500, 0))

	apply_impulse = true



func _on_Timer_timeout():
	applied_force = (PlayerManager.player_position - global_position).normalized() * 500
	print(linear_velocity.length())
