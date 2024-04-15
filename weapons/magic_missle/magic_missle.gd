class_name MagicMissle extends BaseWeapon
# 魔法弹，朝最近的敌人发射一枚飞弹


# [override]
func spawn_projectile() -> BaseProjectile:
	var projectile = create_projectile()
	projectile.top_level = true
	add_child(projectile)
	projectile.global_position = global_position
	projectile.global_rotation = PlayerManager.player_position.angle_to_point(
		EnemyManager.get_closest_enemy_position())
		
	return projectile
