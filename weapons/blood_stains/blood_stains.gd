class_name BloodStains extends BaseWeapon
# 血迹
# 会在走过的路径上留下血迹，对踩在上面的敌人造成伤害


# 在血迹上的敌人，格式为Dictionary[Enemy, int]，表示敌人与敌人所处于的血迹计数
var enemies_on_stains: Dictionary = {}

const DAMAGE_INTERVAL = 1.0

# 武器升级所增加的基础属性增量
# 例：从1级升到2级会添加attribute_delta_list[1]描述的属性增量
var attribute_upgrade_deltas : Array[Dictionary] = [
	{},														# level 0[invalid]
	{"damage": Attribute.new(3.0)},							# level 1
	{"area": Attribute.new(5.0)},							# level 2
	{"damage": Attribute.new(7.0)},							# level 3
	{"area": Attribute.new(5.0)},							# level 4
	{"duration": Attribute.new(1.0)},						# level 5
	{"area": Attribute.new(5.0)},							# level 6
	{"duration": Attribute.new(1.0)},						# level 7
]

func _ready():
	super._ready()
	shooting_timer.start(DAMAGE_INTERVAL)  # 1s造成一次伤害
	shooting_interval_timer.wait_time = attributes["cooldown"].value
	shooting_interval_timer.one_shot = false
	shooting_interval_timer.start()


# [override] 造成伤害
func shoot() -> void:
	var damage_value = attributes["damage"].value
	enemies_on_stains.erase(null)
	for enemy in enemies_on_stains.keys():
		if is_instance_valid(enemy):
			var actual_damage = enemy.character_comp.take_damage(damage_value)
			PlayerManager.spawn_damage_number(enemy.global_position, actual_damage)
			if enemy.character_comp.dead:
				enemies_on_stains.erase(enemy)
	shooting_timer.start(DAMAGE_INTERVAL)

# [override] 生成一块血迹
func shoot_single_projectile() -> void:
	spawn_projectile()

# [override] 构造血迹
func create_projectile() -> BaseProjectile:
	var projectile = super.create_projectile()
	projectile.weapon = self
	return projectile

# [override] 武器升级
func upgrade() -> void:
	if level >= attribute_upgrade_deltas.size():
		return
	for key in attribute_upgrade_deltas[level].keys():
		weapon_attributes[key].apply_modifier(attribute_upgrade_deltas[level][key])
		apply_player_bonus(key)
	level += 1
