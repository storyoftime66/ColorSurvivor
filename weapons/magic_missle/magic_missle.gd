class_name MagicMissle extends BaseWeapon
# 魔法弹，朝最近的敌人发射一枚飞弹


# 武器升级所增加的基础属性增量
# 例：从1级升到2级会添加attribute_delta_list[1]描述的属性增量
var attribute_upgrade_deltas : Array[Dictionary] = [
	{},														# level 0[invalid]
	{"amount": Attribute.new(1.0)},							# level 1
	{"damage": Attribute.new(5.0)},							# level 2
	{"damage": Attribute.new(5.0)},							# level 3
	{"amount": Attribute.new(1.0)},							# level 4
	{"cooldown": Attribute.new(-0.5)},						# level 5
	{"damage": Attribute.new(10.0)},						# level 6
	{"cooldown": Attribute.new(-0.5)},						# level 7
]

# [override]
func spawn_projectile() -> BaseProjectile:
	var projectile = create_projectile()
	projectile.top_level = true
	add_child(projectile)
	projectile.global_position = global_position
	projectile.global_rotation = PlayerManager.player.position.angle_to_point(
		EnemyManager.get_closest_enemy_position())
		
	return projectile

# [override]
func upgrade() -> void:
	if level >= attribute_upgrade_deltas.size():
		return
	for key in attribute_upgrade_deltas[level].keys():
		weapon_attributes[key].apply_modifier(attribute_upgrade_deltas[level][key])
		apply_player_bonus(key)
	level += 1
