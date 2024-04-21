class_name BasePickableItem extends RigidBody2D
# 拾取物基类
# 被拾取时()会朝拾取者飞去，飞行到拾取者的位置后，才会真正被获取

@export var flight_time := 1.0			## 飞行时间
var picker_node: PickupComponent
var is_picked := false
var t := 0.0
var start_pos := Vector2()

func _ready():
	set_physics_process(false)


func _physics_process(delta):
	# 大概0.5s后飞到拾取者处
	t += delta * 2
	position = start_pos.lerp(picker_node.global_position, t)
	if t >= flight_time:
		on_absorbed(picker_node)


# 被捡起时由picker调用
func on_picked_up(picker: PickupComponent) -> void:
	sleeping = false
	picker_node = picker
	start_pos = position
	set_physics_process(true)


# 被吸收时由picker调用
func on_absorbed(picker: PickupComponent) -> void:
	picker.emit_signal("item_absorbed", self)
	queue_free()
