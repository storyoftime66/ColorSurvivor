extends BaseWeapon

class_name MagicMissle
#

func _ready():
	._ready()
	projectile_scene_class = load("res://weapons/magic_missle/magic_missle_projectile.tscn")
	
