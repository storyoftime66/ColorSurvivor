class_name BasePickableItem extends RigidBody2D
## 拾取物基类

export var flight_time := 1.0
var picker_node: Node2D
var is_picked := false
var t := 0.0
var start_pos := Vector2()

func _physics_process(delta):
	if is_picked:
		t += delta
		position = start_pos.linear_interpolate(picker_node.position, t)


# 被捡起时由picker调用
func on_picked_up(picker: Node2D) -> void:
	sleeping = false
	picker_node = picker
	is_picked = true
	start_pos = position


# 被吸收时由picker调用
func on_absorbed(picker: Node2D) -> void:
	queue_free()
