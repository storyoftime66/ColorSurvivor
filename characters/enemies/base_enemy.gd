extends KinematicBody2D

class_name BaseEnemy

# 攻击伤害、移动速度
var damage: float = 5
var movement_speed: float = 100
var health_point: float = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# 承受伤害
func take_damage(damage_amount: float):
	health_point -= damage_amount
	if health_point <= 0:
		die()

# 死亡
func die():
	queue_free()
