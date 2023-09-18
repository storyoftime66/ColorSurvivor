class_name BaseProjectile extends Area2D


# 伤害、范围、飞行速度、持续时间、穿透敌人
var damage: float = 10.0
var area: float = 5.0
var speed: float = 800.0
var duration: float = 3.0
var penetration: int = 1
var impact: float = 500.0

func _ready():
	$LifeSpan.start(duration)

# 向前移动
func _physics_process(delta):
	move_local_x(speed * delta)

# 销毁发射物
func destroy() -> void:
	queue_free()

# 持续时间结束时
func _on_LifeSpan_timeout():
	destroy()

# 命中敌人时
func _on_hit(body):
	var enemy = body as BaseEnemy
	if enemy != null:
		var impact_impulse = Vector2(1.0, 0.0).rotated(rotation) * impact
		var actual_damage = enemy.take_damage(damage, impact_impulse)
		PlayerManager.spawn_damage_number(enemy.position, actual_damage)
	penetration -= 1
	if penetration == 0:
		destroy()
