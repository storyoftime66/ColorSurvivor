extends Node2D

class_name BaseWeapon

export var projectile_scene_class: PackedScene
var main_scene: Node

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
	
	func reset() -> void:
		addition = 0.0
		multiplier = 0.0
		divider = 0.0
		is_dirty = true
	
	func _init(init_base_value: float):
		base_value = init_base_value


# 伤害、范围、发射物飞行速度、发射物持续时间、发射物数量、冷却时间
export var damage: float = 10.0
export var speed: float = 1000.0
export var duration: float = 3.0
export var amount: int = 1
export var cooldown: float = 2.0
export var penetration: int = 1
var shooting_interval: float = 0.05

# 武器属性
var damage_attribute: Attribute
var speed_attribute: Attribute
var duration_attribute: Attribute
var amount_attribute: Attribute
var cooldown_attribute: Attribute
var penetration_attribute: Attribute

# 武器状态
# 单次发射中剩余未发射的数量
var remaining_amount: int = 0

func _ready():
	main_scene = PlayerManager.main_scene
	
	damage_attribute = Attribute.new(damage)
	speed_attribute = Attribute.new(speed)
	duration_attribute = Attribute.new(duration)
	amount_attribute = Attribute.new(amount)
	cooldown_attribute = Attribute.new(cooldown)
	penetration_attribute = Attribute.new(penetration)
	
	$ShootingTimer.start(cooldown_attribute.value)

#func _process(delta):
#	pass

# 生成单个发射物
func spawn_projectile(pos: Vector2, rot: float) -> void:
	var projectile = projectile_scene_class.instance() as BaseProjectile
	projectile.damage = damage_attribute.value
	projectile.speed = speed_attribute.value
	projectile.duration = duration_attribute.value
	projectile.penetration = int(penetration_attribute.value)
	projectile.global_position = global_position
	
	main_scene.add_child(projectile)

# 进行射击
func _on_ShootingTimer_timeout():
	remaining_amount = int(amount_attribute.value)
	$ShootingIntervalTimer.start(max(shooting_interval, 0.05))

# 单发射击
func _on_ShootingIntervalTimer_timeout():
	remaining_amount -= 1
	if remaining_amount >= 0:
		spawn_projectile(global_position, 0)
	else:
		$ShootingIntervalTimer.stop()
		$ShootingTimer.start(cooldown)
