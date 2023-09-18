class_name Onion extends BaseWeapon

# 洋葱，对角色附近敌人周期性造成伤害


# 在范围内的敌人
var enemies_in_range: Array = []

func _ready():
	._ready()
	($DamageArea/CollisionShape2D.shape as CircleShape2D).radius = attributes["area"].value * 16
	$Sprite.scale = Vector2(attributes["area"].value * 0.1808, attributes["area"].value * 0.1808)
	
# 进行射击
func _on_ShootingTimer_timeout():
	for enemy in enemies_in_range:
		if is_instance_valid(enemy):
			var impact_impulse = (enemy.position - PlayerManager.player_position).normalized() * impact
			var actual_damage = (enemy as BaseEnemy).take_damage(damage, impact_impulse)
			PlayerManager.spawn_damage_number(enemy.position, actual_damage)

func _on_DamageArea_body_entered(body):
	var enemy = body as BaseEnemy
	enemies_in_range.append(enemy)

func _on_DamageArea_body_exited(body):
	enemies_in_range.erase(body)
