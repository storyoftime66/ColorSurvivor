class_name FuelDropProjectile extends BaseProjectile


var duration_inverse := 1.0
var elapsed_time := 0.0
var control_point: Vector2

func _ready():
	super._ready()
	duration_inverse = 1 / duration
	control_point = (start_position + target_position) * 0.5 + Vector2(0, randf_range(-200, -400.0))
	
	set_physics_process(false)
	disconnect("body_entered", _on_hit)


func _process(delta):
	elapsed_time += delta
	var t = elapsed_time * duration_inverse
	
	# 计算贝塞尔曲线位置
	var current_position = (start_position.lerp(control_point, t)).lerp(
		control_point.lerp(target_position, t), t)
	global_position = current_position


# 持续时间结束
func _on_LifeSpan_timeout():
	# TODO
	global_position = target_position
	$CollisionShape2D.disabled = false
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		var enemy = body as BaseEnemy
		if enemy != null:
			var impact_impulse = (target_position - enemy.global_position).normalized() * impact
			var actual_damage = enemy.take_damage(damage, impact_impulse)
			PlayerManager.spawn_damage_number(enemy.position, actual_damage)
	destroy()
