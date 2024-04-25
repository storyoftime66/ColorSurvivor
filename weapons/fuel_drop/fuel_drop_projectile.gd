class_name FuelDropProjectile extends BaseProjectile


var duration_inverse := 1.0
var elapsed_time := 0.0
var control_point: Vector2		# 贝塞尔曲线的控制点

@onready var shape = $CollisionShape2D.shape as CircleShape2D

func _ready():
	super._ready()
	duration_inverse = 1 / duration
	control_point = (start_position + target_position) * 0.5 + Vector2(0, randf_range(-200, -400.0))
	
	set_physics_process(false)
	disconnect("body_entered", _on_hit)
	
	shape.radius = area


func _process(delta):
	elapsed_time += delta
	var t = elapsed_time * duration_inverse
	
	# 计算贝塞尔曲线位置
	var current_position = (start_position.lerp(control_point, t)).lerp(
		control_point.lerp(target_position, t), t)
	global_position = current_position


# 持续时间结束
func _on_LifeSpan_timeout():
	global_position = target_position
	
	# 检测命中的敌人
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0.0, global_position)
	query.collision_mask = collision_mask
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var results = space_state.intersect_shape(query)
	
	for result in results:
		var enemy = result.collider as BaseEnemy
		if enemy != null:
			var impact_impulse = (enemy.global_position - target_position).normalized() * impact
			var actual_damage = enemy.character_comp.take_damage(damage, impact_impulse)
			PlayerManager.spawn_damage_number(enemy.position, actual_damage)
	destroy()
