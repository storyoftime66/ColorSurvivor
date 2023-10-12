class_name Knifes extends BaseWeapon

# 飞刀，朝角色面前发射飞刀

func _ready():
	projectile_scene = preload("res://weapons/knifes/knife_projectile.tscn")
	super._ready()

func get_projectile_rot() -> float:
	return PlayerManager.player_orientation
