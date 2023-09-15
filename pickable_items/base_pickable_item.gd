class_name BasePickableItem extends RigidBody2D


# 目标节点
var target_node: Node2D

func _physics_process(delta):
	pass

# 被捡起时由picker调用
func on_picked_up(picker: Node2D) -> void:
	sleeping = false
	target_node = picker

# 被吸收时由picker调用
func on_absorbed(picker: Node2D) -> void:
	queue_free()
