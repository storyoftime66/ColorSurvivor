class_name UltimateVoidEyeProjectile extends BaseProjectile
## 虚空之眼


@onready var laser_shape := $CollisionShape2D
@onready var laser_sprite := $Laser
@onready var laser_duration := $LaserDuration


func _ready():
	# do nothing
	pass


func _physics_process(delta):
	# do nothing
	pass


func start_lasing() -> void:
	laser_shape.set_deferred("disabled", false)
	laser_sprite.show()
	laser_duration.start(duration)


func stop_lasing() -> void:
	laser_shape.set_deferred("disabled", true)
	laser_sprite.hide()


func _on_hit(body):
	var enemy = body as BaseEnemy
	if enemy != null:
		var impact_impulse = Vector2(1.0, 0.0).rotated(global_rotation) * impact
		var actual_damage = enemy.take_damage(damage, impact_impulse)
		PlayerManager.spawn_damage_number(enemy.position, actual_damage)

