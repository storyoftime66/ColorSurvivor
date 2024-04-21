class_name PickupComponent extends Area2D
# 拾取组件，与可拾取物交互


@export var radius := 80.0:			## 拾取半径，单位px
	get:
		return radius
	set(value):
		radius = value
		if is_node_ready():
			collision_shape.radius = radius

@onready var collision_shape := $CollisionShape2D.shape as CircleShape2D


signal item_picked_up(pickable_item: BasePickableItem)
signal item_absorbed(pickable_item: BasePickableItem)


func _ready():
	collision_shape.radius = radius


func _on_body_entered(body):
	var pickable_item = body as BasePickableItem
	if is_instance_valid(pickable_item):
		pickable_item.on_picked_up(self)
		emit_signal("item_picked_up", pickable_item)
