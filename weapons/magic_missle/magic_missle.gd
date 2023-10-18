class_name MagicMissle extends BaseWeapon

# 魔法弹，朝最近的敌人发射一枚飞弹


func _ready():
	projectile_scene = preload("res://weapons/magic_missle/magic_missle_projectile.tscn")
	super._ready()


# 构造发射物并添加到场景中，通常子类需要重写
func spawn_projectile() -> void:
	var projectile = create_projectile()
	projectile.top_level = true
	add_child(projectile)
	projectile.global_position = global_position
	projectile.global_rotation = PlayerManager.player_position.angle_to_point(
		EnemyManager.get_closest_enemy_position())
