class_name PlayerCharacter extends CharacterBody2D
# 玩家角色基类

signal player_character_died()
signal player_character_health_changed(new_health)

# 玩家属性
@export var move_speed := 200.0		## 移动速度，单位像素/秒
@export var armor := 1.0			## 防御力，减少每次受击承受的伤害
@export var max_health := 100.0		## 最大生命值
@export var magnet := 80.0			## 拾取范围，单位像素

# 玩家属性，会作用于武器，类型Dictionary[String, CommonTypes.Attribute]
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

# 组件
@onready var pickup_comp = $PickupComponent as PickupComponent
@onready var level_comp = $LevelComponent as LevelComponent
@onready var weapon_comp = $WeaponComponent as WeaponComponent

func _ready():
	# 角色自身属性
	attributes["move_speed"] = CommonTypes.Attribute.new(move_speed)
	attributes["armor"] = CommonTypes.Attribute.new(armor)
	attributes["max_health"] = CommonTypes.Attribute.new(max_health)
	attributes["magnet"] = CommonTypes.Attribute.new(magnet)
	
	# 角色对武器的增益
	attributes["damage"] = CommonTypes.Attribute.new(0.0)
	attributes["area"] = CommonTypes.Attribute.new(0.0)
	attributes["speed"] = CommonTypes.Attribute.new(0.0)
	attributes["duration"] = CommonTypes.Attribute.new(0.0)
	attributes["amount"] = CommonTypes.Attribute.new(0.0)
	attributes["cooldown"] = CommonTypes.Attribute.new(0.0)
	attributes["penetration"] = CommonTypes.Attribute.new(0.0)
	attributes["impact"] = CommonTypes.Attribute.new(0.0)
	
	health = max_health
	
	level_comp.required_exp_evaluator = get_experience_needed
	pickup_comp.radius = attributes["magnet"].value
	
	screen_size = get_viewport_rect().size
	
	PlayerManager.emit_signal("player_ready", self)
	

func _physics_process(delta):
	# 移动输入处理
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


func get_experience_needed(level: int) -> float:
	return level * (level + 1) * 2.5

func _on_pickup_component_item_absorbed(pickable_item: BasePickableItem):
	# 经验的处理方法
	if pickable_item is Experience:
		level_comp.gain_exp(pickable_item.amount)
		return
