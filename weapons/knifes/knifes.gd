extends BaseWeapon

# 飞刀，朝角色面前发射飞刀
class_name Knifes

func _ready():
	._ready()
	projectile_scene = preload("res://weapons/knifes/knife_projectile.tscn")

func get_target_position() -> Vector2:
	return global_position + Vector2.RIGHT.rotated(PlayerManager.player_orientation)
