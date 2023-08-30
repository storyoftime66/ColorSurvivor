extends RigidBody2D

class_name BaseProjectile

# 伤害、飞行速度、持续时间、穿透敌人
var damage: float = 10
var speed: float = 1000
var duration: float = 3
var penetration: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$LifeSpan.start(duration)


# 持续时间结束时
func _on_LifeSpan_timeout():
	queue_free()

# 命中敌人时
func _on_hit(body):
	(body as BaseEnemy).take_damage(damage)
