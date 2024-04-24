class_name CharacterComponent extends Node
# 角色组件
# 角色组件仅能放在 RigidBody2D 或 CharacterBody2D 下，否则部分功能将无法正常执行


signal health_changed(old_value: float, new_value: float)	## 生命值变化时
signal character_died(comp: CharacterComponent)				## 角色死亡时

@export var max_health := 100.0			## 最大生命值
var health : float :					## 当前生命值
	set=set_health
@export var move_speed := 100.0			## 移动速度，单位px/s
@export var armor := 0.0:				## 护甲，可以提供一定比例的伤害减免
	set=set_armor
@export var mass := 1.0					## 质量，高质量单位受到冲击力的影响较低

var initialized := false				## 组件是否初始化完成
var damage_multiplier := 1.0			## 伤害系数，为0.0时表示完全不受伤害
var dead := false						## 是否已死亡
var is_rigid_body := false				## 是否是刚体
var rigid_body : RigidBody2D			## 刚体父节点


func _ready():
	health = max_health
	if is_instance_of(get_parent(), RigidBody2D):
		rigid_body = get_parent() as RigidBody2D
		rigid_body.mass = mass
		is_rigid_body = true
		
	initialized = true


func set_health(value: float):
	value = clampf(value, 0.0, max_health)
	if health == value:
		return
		
	var old_value = health
	health = value
	if initialized:
		emit_signal("health_changed", old_value, health)
		if health == 0.0 and not dead:
			# 只能死一次
			dead = true
			emit_signal("character_died", self)


func set_armor(value: float):
	value = clampf(value, -9.0, 1000.0)
	if armor != value:
		armor = value
		damage_multiplier = 1 - (armor / (armor + 10.0))


# 受到伤害
# @param origin_value 受到的伤害（未经过伤害减免）
# @param impact 冲击力
# @return 受到的实际伤害（经过伤害减免）
func take_damage(origin_value: float, impact: Vector2 = Vector2.ZERO) -> float:
	var actual_value = origin_value * damage_multiplier
	health -= actual_value
	if is_rigid_body and not dead:
		rigid_body.apply_central_impulse(impact)
	return actual_value
