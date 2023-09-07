extends BaseWeapon

class_name MagicMissle
#

func _ready():
	._ready()
	projectile_scene_class = load("res://weapons/magic_missle/magic_missle_projectile.tscn")
	
func _on_ShootingIntervalTimer_timeout():
	remaining_amount -= 1
	if remaining_amount >= 0:
		spawn_projectile(EnemyManager.get_closest_enemy_position())
	else:
		$ShootingIntervalTimer.stop()
		$ShootingTimer.start(cooldown)
