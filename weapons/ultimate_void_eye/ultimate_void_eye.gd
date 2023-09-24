class_name UltimateVoidEye extends BaseWeapon
## 虚空之眼


var eyes: Array[UltimateVoidEyeProjectile]
var eye_num := 0


func spawn_projectile() -> void:
	var projectile = create_projectile()
	
	level_node.add_child(projectile)
	projectile.position = get_projectile_pos()
	projectile.rotation = get_projectile_rot()
	
	
