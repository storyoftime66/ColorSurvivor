class_name BaseEnemy extends RigidBody2D
# 敌人基类

@export var attack_damage: float = 5.0			## 攻击伤害
@export var xp_amount: float = 1.0		## 经验值

@onready var attack_timer := $AttackTimer as Timer
@onready var character_comp := $CharacterComponent as CharacterComponent

# 状态
var player: PlayerCharacter
# 敌人移动推力的大小
var speed_force_length := 0.0


func _ready():
	speed_force_length = character_comp.move_speed * character_comp.mass * linear_damp


# 对玩家造成伤害
func _on_AttackRange_body_entered(body):
	player = body as PlayerCharacter
	attack_timer.start()


func _on_AttackRange_body_exited(_body):
	player = null
	attack_timer.stop()


func _on_AttackTimer_timeout() -> void:
	if is_instance_valid(player):
		player.character_comp.take_damage(attack_damage)


func _on_MovementTimer_timeout() -> void:
	# TODO: 优化移动方式
	constant_force = (PlayerManager.players[0].position - position).normalized() * speed_force_length


func _on_character_component_character_died(comp):
	EnemyManager.spawn_experience(xp_amount, position)
	queue_free()
