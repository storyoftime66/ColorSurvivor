class_name Knifes extends BaseWeapon

# 飞刀，朝角色面前发射飞刀

func _ready():
	super._ready()
	projectile_scene = preload("res://weapons/knifes/knife_projectile.tscn")

func get_projectile_rot() -> float:
	return PlayerManager.player_orientation
