class_name PlayerCharacter extends CharacterBody2D

## 玩家角色基类
signal player_character_died()
signal player_character_health_changed(new_health)

# 玩家属性
# 移动速度，单位像素/秒
@export var move_speed := 200.0
# 防御力，减少每次受击承受的伤害
@export var armor := 1.0
# 最大生命值
@export var max_health := 20.0
# 拾取范围，单位像素
@export var magnet := 80.0

# 玩家属性
var attributes: Dictionary = {}

# 玩家状态
var movement_input := Vector2.ZERO
var health :float:
	get:
		return health
	set(value):
		if health != value:
			health = clampf(value, 0.0, max_health)
			emit_signal("player_character_health_changed", health)
			$HealthBar.value = health / max_health

# 屏幕大小
var screen_size: Vector2

func _ready():
	attributes["move_speed"] = CommonTypes.Attribute.new(move_speed)
	attributes["armor"] = CommonTypes.Attribute.new(armor)
	attributes["max_health"] = CommonTypes.Attribute.new(max_health)
	attributes["magnet"] = CommonTypes.Attribute.new(magnet)
	
	health = max_health
	
	($PickupRange/PickupRangeShape.shape as CircleShape2D).radius = attributes["magnet"].value
	
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
	var movement_direction = movement_input.normalized()
	set_velocity(movement_direction * attributes["move_speed"].value)
	move_and_slide()
	var velocity = velocity
	
# TODO: 受到伤害，返回实际受到的伤害
func take_damage(damage_amount: float) -> float:
	var actual_damage_amount = max(damage_amount - attributes["armor"].value, 0.0)
	health -= actual_damage_amount
	if health <= 0.0:
		emit_signal("player_character_died")
	
	return actual_damage_amount

func _on_PickupRange_body_entered(body):
	var pickable_item = body as BasePickableItem
	if is_instance_valid(pickable_item):
		pickable_item.on_picked_up(self)

