class_name BaseWeapon extends Node2D
## 武器基类


# 武器的发射物类
var projectile_scene: PackedScene
@onready var level_node := PlayerManager.level_node
@onready var shooting_timer := $ShootingTimer as Timer
@onready var shooting_interval_timer := $ShootingIntervalTimer as Timer

# 伤害、范围、发射物飞行速度、发射物持续时间、发射物数量、冷却时间、冲击力
@export var damage: float = 10.0
@export var area: float = 5.0
@export var speed: float = 1000.0
@export var duration: float = 3.0
@export var amount: int = 1
@export var cooldown: float = 2.0
@export var penetration: int = 1
@export var impact: float = 500.0

# 连续射击时的射击间隔，通常为常数
var shooting_interval: float = 0.05

# 武器基本属性，类型: Dictionary[str, Attribute]
var weapon_attributes: Dictionary = {}
# 经过角色增益后的武器属性
var attributes: Dictionary = {}

# 武器状态
# 单次发射中剩余未发射的数量
var remaining_amount: int = 0
var player_character: PlayerCharacter


func _ready():
	# 初始化属性
	weapon_attributes["damage"] = CommonTypes.Attribute.new(damage)
	weapon_attributes["area"] = CommonTypes.Attribute.new(area)
	weapon_attributes["speed"] = CommonTypes.Attribute.new(speed)
	weapon_attributes["duration"] = CommonTypes.Attribute.new(duration)
	weapon_attributes["amount"] = CommonTypes.Attribute.new(amount)
	weapon_attributes["cooldown"] = CommonTypes.Attribute.new(cooldown)
	weapon_attributes["penetration"] = CommonTypes.Attribute.new(penetration)
	weapon_attributes["impact"] = CommonTypes.Attribute.new(impact)
	
	assert(player_character != null)
	attributes = weapon_attributes.duplicate(true)
	apply_all_player_bonus()
	
	shooting_timer.start(attributes["cooldown"].value)


# 应用增益
func apply_bonus(attribute_name: String, bonus: CommonTypes.Attribute) -> void:
	attributes[attribute_name] = weapon_attributes[attribute_name].duplicate_and_apply_modifier(bonus)
	
# 应用所有增益
func apply_all_bonus(bonus_dict: Dictionary) -> void:
	for key in weapon_attributes.keys():
		if bonus_dict.has(key) and bonus_dict[key] is CommonTypes.Attribute:
			apply_bonus(key, bonus_dict[key])


# 应用玩家角色的增益
func apply_player_bonus(attribute_name: String) -> void:
	apply_bonus(attribute_name, player_character.attributes[attribute_name])
	
# 应用角色的所有增益
func apply_all_player_bonus() -> void:
	apply_all_bonus(player_character.attributes)

# 构造发射物
func create_projectile() -> BaseProjectile:
	var projectile = projectile_scene.instantiate() as BaseProjectile
	projectile.damage = attributes["damage"].value
	projectile.area = attributes["area"].value
	projectile.speed = attributes["speed"].value
	projectile.duration = attributes["duration"].value
	projectile.penetration = int(attributes["penetration"].value)
	projectile.impact = attributes["impact"].value
	return projectile


# 构造发射物并添加到场景中
func spawn_projectile() -> void:
	var projectile = create_projectile()
	projectile.top_level = true
	add_child(projectile)
	projectile.global_position = get_projectile_pos()
	projectile.global_rotation = get_projectile_rot()


# 获取发射物的生成位置，通常子类需要重写
func get_projectile_pos() -> Vector2:
	return global_position


# 获取发射物的生成旋转，通常子类需要重写
func get_projectile_rot() -> float:
	return global_rotation


# 进行射击
func shoot() -> void:
	remaining_amount = int(attributes["amount"].value)
	shooting_interval_timer.start(shooting_interval)
	
	var interval_between_shots = attributes["cooldown"].value + attributes["amount"].value * shooting_interval
	shooting_timer.start(interval_between_shots)


# 单发射击（子类通常需要重载这个方法来实现自己的射击效果）
func shoot_single_projectile() -> void:
	remaining_amount -= 1
	if remaining_amount >= 0:
		spawn_projectile()
	else:
		shooting_interval_timer.stop()


# 升级
func upgrade() -> void:
	print("%s.upgrade() has NOT been implemented" % self)
