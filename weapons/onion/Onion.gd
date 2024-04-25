class_name Onion extends BaseWeapon
# 洋葱，对角色附近敌人周期性造成伤害


# 在范围内的敌人
var enemies_in_range: Array[BaseEnemy] = []

func _ready():
	super._ready()
	($DamageArea/CollisionShape2D.shape as CircleShape2D).radius = attributes["area"].value * 16
	$Sprite2D.scale = Vector2(attributes["area"].value * 0.1808, attributes["area"].value * 0.1808)
	
# [override] 进行射击
func shoot():
	for enemy in enemies_in_range:
		if is_instance_valid(enemy):
			var impact_impulse = (enemy.global_position - global_position).normalized() * impact
			var actual_damage = enemy.character_comp.take_damage(damage, impact_impulse)
			PlayerManager.spawn_damage_number(enemy.position, actual_damage)

func _on_DamageArea_body_entered(body):
	var enemy = body as BaseEnemy
	enemies_in_range.append(enemy)

func _on_DamageArea_body_exited(body):
	enemies_in_range.erase(body)
