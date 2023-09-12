extends BaseWeapon

# 魔法弹，朝最近的敌人发射一枚飞弹
class_name MagicMissle

func _ready():
	._ready()
	projectile_scene = preload("res://weapons/magic_missle/magic_missle_projectile.tscn")
	
func get_target_position() -> Vector2:
	return EnemyManager.get_closest_enemy_position()
