extends KinematicBody2D

# 玩家基类
class_name PlayerCharacter

# 玩家属性
export var speed: float = 300.0

# 玩家状态
var movement_input: Vector2 = Vector2.ZERO

# 屏幕大小
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

# 移动输入处理
func _physics_process(delta):
	movement_input = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		movement_input.x -= 1
	if Input.is_action_pressed("move_right"):
		movement_input.x += 1
	if Input.is_action_pressed("move_up"):
		movement_input.y -= 1
	if Input.is_action_pressed("move_down"):
		movement_input.y += 1
	
	var velocity = move_and_slide(movement_input.normalized() * speed)
	#	position.x = clamp(position.x, 0, screen_size.x)
	#	position.y = clamp(position.y, 0, screen_size.y)
	
# 受到伤害，返回实际受到的伤害
func take_damage(damage_amount: float) -> float:
	return damage_amount

