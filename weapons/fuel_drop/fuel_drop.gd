class_name FuelDrop extends BaseWeapon
## 爆炸液滴

# [override]
func spawn_projectile() -> void:
	var projectile = create_projectile()
	projectile.duration = randf_range(0.8, 1.2)
	projectile.top_level = true
	
	# 设定落点，落点仅会在左侧或右侧
	var direction = -1.0 if randf() > 0.5 else 1.0
	var destination_rot = deg_to_rad(90.0 + randf_range(45.0, 135.0) * direction)
	var destination_distance = randf_range(200, 400)
	var start_pos = global_position
	projectile.start_position = start_pos
	projectile.target_position = start_pos + Vector2(destination_distance, 0).rotated(destination_rot)
	
	# 添加到场景中，并设定初始位置和朝向
	add_child(projectile)
	var start_rot = deg_to_rad(90.0 + randf_range(15.0, 30.0) * direction)
	projectile.global_position = start_pos
	projectile.global_rotation = start_rot
