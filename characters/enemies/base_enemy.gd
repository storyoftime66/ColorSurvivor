extends KinematicBody2D

class_name BaseEnemy

# 敌人基类，敌人处于Layer1

# 属性：攻击伤害、移动速度
var attack_damage: float = 5.0
var movement_speed: float = 100.0
var health_point: float = 10.0

# 状态
var player: PlayerCharacter


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	move_and_slide((PlayerManager.player_position - position).normalized() * movement_speed)

# 受到伤害，返回实际受到的伤害值
func take_damage(damage: float) -> float:
	health_point -= damage
	if health_point <= 0:
		die()
	return 0.0

# 死亡
func die():
	queue_free()


func _on_AttackRange_body_entered(body):
	player = body as PlayerCharacter
	$AttackTimer.start()
	
func _on_AttackRange_body_exited(_body):
	player = null
	$AttackTimer.stop()

func _on_AttackTimer_timeout() -> void:
	player.take_damage(attack_damage)


