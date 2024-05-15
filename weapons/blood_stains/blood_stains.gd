class_name BloodStains extends BaseWeapon
# 血迹
# 会在走过的路径上留下血迹，对踩在上面的敌人造成伤害


# 在血迹上的敌人，格式为Dictionary[Enemy, int]，表示敌人与敌人所处于的血迹计数
var enemies_on_stains: Dictionary = {}

func _ready():
	super._ready()
	shooting_timer.start(0.5)
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
	shooting_timer.start(0.5)

# [override] 生成一块血迹
func shoot_single_projectile() -> void:
	spawn_projectile()

# [override] 构造血迹
func create_projectile() -> BaseProjectile:
	var projectile = super.create_projectile()
	projectile.weapon = self
	return projectile
