class_name Onion extends BaseWeapon
# 洋葱，对角色附近敌人周期性造成伤害


var enemies_in_range: Array[BaseEnemy] = []			# 在范围内的敌人

@onready var collision_shape := $DamageArea/CollisionShape2D.shape as CircleShape2D
@onready var sprite2d := $Sprite2D as Sprite2D

# 武器升级所增加的基础属性增量
# 例：从1级升到2级会添加attribute_delta_list[1]描述的属性增量
var attribute_upgrade_deltas : Array[Dictionary] = [
	{},														# level 0[invalid]
	{"damage": Attribute.new(1.0)},							# level 1
	{"area": Attribute.new(20.0)},							# level 2
	{"impact": Attribute.new(50.0)},						# level 3
	{"damage": Attribute.new(2.0)},							# level 4
	{"impact": Attribute.new(50.0)},						# level 5
	{"area": Attribute.new(50.0)},							# level 6
	{"damage": Attribute.new(5.0)},							# level 7
]

func _ready():
	super._ready()
	update_style()


# [override] 进行射击
func shoot():
	var damage = attributes["damage"].value
	var impact = attributes["impact"].value
	for enemy in enemies_in_range:
		if is_instance_valid(enemy):
			var impact_impulse = (enemy.global_position - global_position).normalized() * impact
			var actual_damage = enemy.character_comp.take_damage(damage, impact_impulse)
			PlayerManager.spawn_damage_number(enemy.position, actual_damage)


# [override] 武器升级
func upgrade() -> void:
	if level >= attribute_upgrade_deltas.size():
		return
	for key in attribute_upgrade_deltas[level].keys():
		weapon_attributes[key].apply_modifier(attribute_upgrade_deltas[level][key])
		apply_player_bonus(key)
	level += 1
	update_style()
	
	
# 更新武器的视觉展示效果
func update_style() -> void:
	collision_shape.radius = attributes["area"].value
	# 缩放sprite
	sprite2d.scale = Vector2(
		attributes["area"].value * 0.0113,
		attributes["area"].value * 0.0113
	)


func _on_DamageArea_body_entered(body):
	var enemy = body as BaseEnemy
	enemies_in_range.append(enemy)


func _on_DamageArea_body_exited(body):
	enemies_in_range.erase(body)
