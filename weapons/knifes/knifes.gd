class_name Knifes extends BaseWeapon
# 飞刀，朝角色面前发射飞刀


# [override]
func spawn_projectile() -> BaseProjectile:
	var projectile = create_projectile()
	projectile.top_level = true
	add_child(projectile)
	projectile.global_position = global_position
	projectile.global_rotation = PlayerManager.players[0].orientation
	
	return projectile
