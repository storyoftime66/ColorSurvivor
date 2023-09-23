class_name BasePickableItem extends RigidBody2D
## 拾取物基类

@export var flight_time := 1.0
var picker_node: Node2D
var is_picked := false
var t := 0.0
var start_pos := Vector2()

func _ready():
	set_physics_process(false)


func _physics_process(delta):
	t += delta * 2.0
	position = start_pos.lerp(picker_node.position, t)
	if t > 1.0:
		on_absorbed(picker_node)


# 被捡起时由picker调用
func on_picked_up(picker: Node2D) -> void:
	sleeping = false
	picker_node = picker
	start_pos = position
	set_physics_process(true)


# 被吸收时由picker调用
func on_absorbed(picker: Node2D) -> void:
	queue_free()
