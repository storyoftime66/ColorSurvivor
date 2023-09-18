class_name MagicMissle extends BaseWeapon

# 魔法弹，朝最近的敌人发射一枚飞弹


func _ready():
	._ready()
	projectile_scene = preload("res://weapons/magic_missle/magic_missle_projectile.tscn")
	
func get_projectile_rot() -> float:
	return PlayerManager.player_position.angle_to_point(EnemyManager.get_closest_enemy_position())
