extends BaseProjectile

class_name MagicMissleProjectile

func _process(delta):
	move_local_x(speed * delta)
