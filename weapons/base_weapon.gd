extends Node2D

# 属性类
# 属性可以添加加成和减益，并通过一个计算公式得出实际属性值
class Attribute:
	# 属性值，current_value的别名
	var value: float setget , get_value
	
	var base_value: float setget set_base_value, get_base_value
	var current_value: float setget , get_value
	var addition: float = 0.0 setget set_addition, get_addition
	var multiplier: float = 0.0 setget set_multiplier, get_multiplier
	var divider: float = 0.0 setget set_divider, get_divider
	var is_dirty: bool = true
	
	func get_value() -> float:
		if is_dirty:
			current_value = (base_value * (1.0 + multiplier) + addition) * max(0.01, 1.0 - divider)
			is_dirty = false
		return current_value
	
	func set_base_value(new_value: float) -> void:
		base_value = new_value
		is_dirty = true
	
	func get_base_value() -> float:
		return base_value
	
	func set_addition(new_value: float) -> void:
		addition = new_value
		is_dirty = true
	
	func get_addition() -> float:
		return addition
	
	func set_multiplier(new_value: float) -> void:
		multiplier = new_value
		is_dirty = true
	
	func get_multiplier() -> float:
		return multiplier
	
	func set_divider(new_value: float) -> void:
		divider = new_value
		is_dirty = true
	
	func get_divider() -> float:
		return divider
	
	func add_modifiers(other: Attribute) -> void:
		addition += other.addition
		multiplier += other.multiplier
		divider += other.divider
		is_dirty = true
	
	func reset() -> void:
		addition = 0.0
		multiplier = 0.0
		divider = 0.0
		is_dirty = true
	
	func _init(init_base_value: float):
		base_value = init_base_value

# 武器基类
class_name BaseWeapon

# 发射物类
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
	attributes["damage"] = Attribute.new(damage)
	attributes["area"] = Attribute.new(area)
	attributes["speed"] = Attribute.new(speed)
	attributes["duration"] = Attribute.new(duration)
	attributes["amount"] = Attribute.new(amount)
	attributes["cooldown"] = Attribute.new(cooldown)
	attributes["penetration"] = Attribute.new(penetration)
	attributes["impact"] = Attribute.new(impact)
	
	$ShootingTimer.start(attributes["cooldown"].value)

# 应用角色的增益
func apply_bonus(bonus: Dictionary) -> void:
	for key in attributes.keys():
		if bonus[key] is Attribute:
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
func spawn_projectile(target_pos: Vector2) -> void:
	var projectile = create_projectile()
	
	main_node.add_child(projectile)
	projectile.global_position = global_position
	projectile.look_at(target_pos)

# 获取发射物的目标点，通常子类需要重写
func get_target_position() -> Vector2:
	return global_position + Vector2(1, 0)

# 进行射击
func _on_ShootingTimer_timeout():
	remaining_amount = int(attributes["amount"].value)
	$ShootingIntervalTimer.start(shooting_interval)

# 单发射击（子类通常需要重载这个方法来实现自己的射击效果）
func _on_ShootingIntervalTimer_timeout():
	remaining_amount -= 1
	if remaining_amount >= 0:
		spawn_projectile(get_target_position())
	else:
		$ShootingIntervalTimer.stop()
		$ShootingTimer.start(cooldown)

# 升级
func upgrade() -> void:
	pass
