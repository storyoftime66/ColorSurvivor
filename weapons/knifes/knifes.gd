class_name Knifes extends BaseWeapon

# 飞刀，朝角色面前发射飞刀

func _ready():
	projectile_scene = preload("res://weapons/knifes/knife_projectile.tscn")
	super._ready()


func spawn_projectile() -> void:
	var projectile = create_projectile()
	projectile.top_level = true
	add_child(projectile)
	projectile.global_position = global_position
	projectile.global_rotation = PlayerManager.player_orientation
