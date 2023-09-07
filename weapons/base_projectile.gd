extends Area2D

class_name BaseProjectile

# 伤害、飞行速度、持续时间、穿透敌人
var damage: float = 10.0
var speed: float = 800.0
var duration: float = 3.0
var penetration: int = 1

func _ready():
	$LifeSpan.start(duration)

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
		enemy.take_damage(damage)
	penetration -= 1
	if penetration == 0:
		destroy()
