class_name BaseWeapon extends Node2D
# 武器基类
# 武器属性由武器基础属性与角色加成计算而来，读取attributes[attr_name]即可
# 其中attr_name在以下字符串中选择：
# damage, area, speed, duration, amount, cooldown, penetration, impact


const Attribute = CommonTypes.Attribute

@onready var shooting_timer := $ShootingTimer as Timer
@onready var shooting_interval_timer := $ShootingIntervalTimer as Timer

# 武器初始属性
@export var projectile_scene: PackedScene	## 武器发射物类
@export var damage: float = 10.0			## 伤害
@export var area: float = 5.0				## 伤害范围，单位px
@export var speed: float = 1000.0			## 发射物飞行速度
@export var duration: float = 3.0			## 发射物持续时间，单位秒
@export var amount: int = 1					## 发射物数量
@export var cooldown: float = 2.0			## 冷却时间，单位秒
@export var penetration: int = 1			## 穿透数量
@export var impact: float = 500.0			## 冲击力，可对敌人造成击退

# 武器属性
var init_weapon_attributes: Dictionary = {}	## 初始基础属性，便于武器升级时在此基础做增量
var weapon_attributes: Dictionary = {}		## 武器基础属性，类型: Dictionary[str, Attribute]
var attributes: Dictionary = {}				## 经过增益后的武器属性

# 武器状态
var level := 1								## 武器等级
var remaining_amount: int = 0				## 单次发射中剩余未发射的数量
var shooting_interval: float = 0.05			## 连续射击时的射击间隔，通常为常数
var weapon_comp: WeaponComponent			## 持有者的武器组件


func _ready():
	# 初始化属性
	init_weapon_attributes["damage"] = Attribute.new(damage)
	init_weapon_attributes["area"] = Attribute.new(area)
	init_weapon_attributes["speed"] = Attribute.new(speed)
	init_weapon_attributes["duration"] = Attribute.new(duration)
	init_weapon_attributes["amount"] = Attribute.new(amount)
	init_weapon_attributes["cooldown"] = Attribute.new(cooldown)
	init_weapon_attributes["penetration"] = Attribute.new(penetration)
	init_weapon_attributes["impact"] = Attribute.new(impact)
	
	weapon_attributes = init_weapon_attributes.duplicate(true)
	attributes = weapon_attributes.duplicate(true)
	apply_all_player_bonus()
	shooting_timer.start(attributes["cooldown"].value)


#region Bonus
# 应用增益
func apply_bonus(attribute_name: String, bonus: Attribute) -> void:
	attributes[attribute_name] = weapon_attributes[attribute_name].duplicate_and_apply_modifier(bonus)
	
# 应用所有增益
func apply_all_bonus(bonus_dict: Dictionary) -> void:
	for key in weapon_attributes.keys():
		if bonus_dict.has(key) and bonus_dict[key] is Attribute:
			apply_bonus(key, bonus_dict[key])

# 应用玩家角色的增益
func apply_player_bonus(attribute_name: String) -> void:
	apply_bonus(attribute_name, weapon_comp.bonus[attribute_name])
	
# 应用角色的所有增益
func apply_all_player_bonus() -> void:
	apply_all_bonus(weapon_comp.bonus)
#endregion


# [需要重载] 构造发射物并设置发射物属性，可能会需要进行其他初始化操作，在子类重载中实现
func create_projectile() -> BaseProjectile:
	var projectile = projectile_scene.instantiate() as BaseProjectile
	projectile.damage = attributes["damage"].value
	projectile.area = attributes["area"].value
	projectile.speed = attributes["speed"].value
	projectile.duration = attributes["duration"].value
	projectile.penetration = int(attributes["penetration"].value)
	projectile.impact = attributes["impact"].value
	return projectile


# [需要重载] 构造发射物并添加到场景中，通常子类需要重写
func spawn_projectile() -> BaseProjectile:
	var projectile = create_projectile()
	projectile.top_level = true
	add_child(projectile)
	projectile.global_position = global_position
	projectile.global_rotation = global_rotation
	return projectile


# [需要重载] 进行射击，由ShootingTimer触发
# 注意：每次射击可能会调用多次shoot_single_projectile()，用于生成多发子弹
func shoot() -> void:
	remaining_amount = int(attributes["amount"].value)
	shooting_interval_timer.start(shooting_interval)
	
	var interval_between_shots = attributes["cooldown"].value + attributes["amount"].value * shooting_interval
	shooting_timer.start(interval_between_shots)


# [需要重载] 单发射击，由ShootIntervalTimer触发
# 子类通常需要重载这个方法来实现自己的射击效果
func shoot_single_projectile() -> void:
	remaining_amount -= 1
	if remaining_amount >= 0:
		spawn_projectile()
	else:
		shooting_interval_timer.stop()


# 升级
func upgrade() -> void:
	print("%s.upgrade() has NOT been implemented" % self)
