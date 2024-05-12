class_name Knifes extends BaseWeapon
# 飞刀，朝角色面前发射飞刀


var rng = RandomNumberGenerator.new()
const OFFSET_RANGE = 10.0

# 武器升级所增加的基础属性增量
# 例：从1级升到2级会添加attribute_delta_list[1]描述的属性增量
var attribute_upgrade_deltas : Array[Dictionary] = [
	{},														# level 0[invalid]
	{"amount": Attribute.new(1.0)},							# level 1
	{"damage": Attribute.new(5.0)},							# level 2
	{"penetration": Attribute.new(1.0)},					# level 3
	{"impact": Attribute.new(300.0)},						# level 4
	{"amount": Attribute.new(2.0)},							# level 5
	{"damage": Attribute.new(10.0)},						# level 6
	{"amount": Attribute.new(3.0)},							# level 7
	{"penetration": Attribute.new(2.0)},					# level 8
	{"cooldown": Attribute.new(-1.0)},						# level 9
]

# [override]
func spawn_projectile() -> BaseProjectile:
	var projectile = create_projectile()
	projectile.top_level = true
	add_child(projectile)
	var orientation = PlayerManager.player.orientation
	var offset = Vector2(0, 1).rotated(orientation) * rng.randf_range(-1.0, 1.0)
	var projectile_position = global_position + offset * OFFSET_RANGE
	projectile.global_position = projectile_position
	projectile.global_rotation = orientation
	
	return projectile

# [override] 武器升级
func upgrade() -> void:
	if level >= attribute_upgrade_deltas.size():
		return
	for key in attribute_upgrade_deltas[level].keys():
		weapon_attributes[key].apply_modifier(attribute_upgrade_deltas[level][key])
		apply_player_bonus(key)
	level += 1
