extends KinematicBody2D

class_name PlayerCharacter

# 移动速度
export (float) var speed = 300
export (float) var damage = 5

# 屏幕大小
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

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
	
