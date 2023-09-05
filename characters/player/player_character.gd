extends KinematicBody2D

class_name PlayerCharacter

# 玩家基类，玩家处于Layer2

# 玩家属性
export var speed: float = 300.0
export var damage: float = 5.0

# 屏幕大小
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

# 移动输入处理
func _physics_process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)
	#	position.x = clamp(position.x, 0, screen_size.x)
	#	position.y = clamp(position.y, 0, screen_size.y)
	
# 受到伤害，返回实际受到的伤害
func take_damage(damage: float) -> float:
	return 0.0
	
#func _process(delta):
#	print(position)
