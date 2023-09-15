class_name PlayerCharacter extends KinematicBody2D

"""
玩家角色基类
"""


# 玩家属性
# 移动速度，单位像素/秒
export var move_speed := 300.0
# 防御力，减少每次受击承受的伤害
export var armor := 1.0
# 最大生命值
export var max_health := 20.0
# 拾取范围，单位像素
export var magnet := 50.0

# 玩家属性
var attributes: Dictionary = {}

# 玩家状态
var movement_input := Vector2.ZERO
var health := max_health

# 屏幕大小
var screen_size: Vector2

func _ready():
	attributes["move_speed"] = CommonTypes.Attribute.new(move_speed)
	attributes["armor"] = CommonTypes.Attribute.new(armor)
	attributes["max_health"] = CommonTypes.Attribute.new(max_health)
	attributes["magnet"] = CommonTypes.Attribute.new(magnet)
	
	screen_size = get_viewport_rect().size

# 移动输入处理
func _physics_process(delta):
	movement_input = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		movement_input.x -= 1
	if Input.is_action_pressed("move_right"):
		movement_input.x += 1
	if Input.is_action_pressed("move_up"):
		movement_input.y -= 1
	if Input.is_action_pressed("move_down"):
		movement_input.y += 1
	var velocity = move_and_slide(movement_input.normalized() * attributes["move_speed"].value)
	
# TODO: 受到伤害，返回实际受到的伤害
func take_damage(damage_amount: float) -> float:
	return max(damage_amount - attributes["armor"].value, 0.0)

func _on_PickupRange_body_entered(body):
	var pickable_item = body as BasePickableItem
	if is_instance_valid(pickable_item):
		pickable_item.on_picked_up(self)


func _on_AbsorptionRange_body_entered(body):
	var pickable_item = body as BasePickableItem
	if is_instance_valid(pickable_item):
		pickable_item.on_absorbed(self)
