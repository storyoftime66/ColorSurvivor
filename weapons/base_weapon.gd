class_name BaseWeapon extends Node2D

# 武器基类

# 武器的发射物类
export var projectile_scene: PackedScene
var main_node: Node

# 伤害、范围、发射物飞行速度、发射物持续时间、发射物数量、冷却时间、冲击力
export var damage: float = 10.0
export var area: float = 5.0
export var speed: float = 1000.0
export var duration: float = 3.0
export var amount: int = 1
export var cooldown: float = 2.0
export var penetration: int = 1
export var impact: float = 500.0

# 连续射击时的射击间隔
const shooting_interval: float = 0.05

# 武器属性，类型: Dictionary[str, Attribute]
var attributes: Dictionary = {}

# 武器状态
# 单次发射中剩余未发射的数量
var remaining_amount: int = 0

func _ready():
	main_node = WeaponManager.main_node
	
	# 初始化属性
	attributes["damage"] = CommonTypes.Attribute.new(damage)
	attributes["area"] = CommonTypes.Attribute.new(area)
	attributes["speed"] = CommonTypes.Attribute.new(speed)
	attributes["duration"] = CommonTypes.Attribute.new(duration)
	attributes["amount"] = CommonTypes.Attribute.new(amount)
	attributes["cooldown"] = CommonTypes.Attribute.new(cooldown)
	attributes["penetration"] = CommonTypes.Attribute.new(penetration)
	attributes["impact"] = CommonTypes.Attribute.new(impact)
	
	$ShootingTimer.start(attributes["cooldown"].value)

# 应用角色的增益
func apply_bonus(bonus: Dictionary) -> void:
	for key in attributes.keys():
		if bonus[key] is CommonTypes.Attribute:
			attributes[key].add_modifiers(bonus[key])

# 构造发射物
func create_projectile() -> BaseProjectile:
	var projectile = projectile_scene.instance() as BaseProjectile
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
	
	main_node.add_child(projectile)
	# 武器在玩家角色身上，需要计算武器在Main中的位置
	projectile.position = get_projectile_pos()
	projectile.rotation = get_projectile_rot()


# 获取发射物的生成位置，通常子类需要重写
func get_projectile_pos() -> Vector2:
	return position + PlayerManager.player_position


# 获取发射物的生成旋转，通常子类需要重写
func get_projectile_rot() -> float:
	return rotation + PlayerManager.player_orientation


# 进行射击
func _on_ShootingTimer_timeout():
	remaining_amount = int(attributes["amount"].value)
	$ShootingIntervalTimer.start(shooting_interval)


# 单发射击（子类通常需要重载这个方法来实现自己的射击效果）
func _on_ShootingIntervalTimer_timeout():
	remaining_amount -= 1
	if remaining_amount >= 0:
		spawn_projectile()
	else:
		$ShootingIntervalTimer.stop()
		$ShootingTimer.start(cooldown)

# 升级
func upgrade() -> void:
	pass
