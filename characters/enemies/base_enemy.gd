extends RigidBody2D

# 敌人基类
class_name BaseEnemy

signal enemy_died(enemy)

# 属性：攻击伤害、移动速度、血量
export var attack_damage: float = 5.0
export var speed: float = 100.0
export var health: float = 10.0

# 状态
var player: PlayerCharacter
# 敌人移动推力的大小
var speed_force_length := 0.0

func _ready():
	speed_force_length = speed * mass * linear_damp

#func _physics_process(delta):
#	apply_central_impulse((PlayerManager.player_position - global_position).normalized() * movement_speed)

# 受到伤害，返回实际受到的伤害值
func take_damage(damage: float, impact: Vector2 = Vector2.ZERO) -> float:
	health -= damage
	if health <= 0:
		die()
	else:
		apply_central_impulse(impact)
	return damage

# 死亡
func die():
	emit_signal("enemy_died", self)
	queue_free()

# 对玩家造成伤害
func _on_AttackRange_body_entered(body):
	player = body as PlayerCharacter
	$AttackTimer.start()
	
func _on_AttackRange_body_exited(_body):
	player = null
	$AttackTimer.stop()

func _on_AttackTimer_timeout() -> void:
	if is_instance_valid(player):
		player.take_damage(attack_damage)

func _on_MovementTimer_timeout() -> void:
	applied_force = (PlayerManager.player_position - global_position).normalized() * speed_force_length
