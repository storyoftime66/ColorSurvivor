class_name PlayerCharacter extends CharacterBody2D
# 玩家角色基类

signal player_character_health_changed(new_health)


# 玩家属性，会作用于武器，类型Dictionary[String, CommonTypes.Attribute]
var attributes: Dictionary = {}

# 屏幕大小
var screen_size: Vector2

# 组件
@onready var pickup_comp = $PickupComponent as PickupComponent
@onready var level_comp = $LevelComponent as LevelComponent
@onready var weapon_comp = $WeaponComponent as WeaponComponent
@onready var character_comp = $CharacterComponent as CharacterComponent

var movement_input: Vector2


func _ready():
	# 角色自身属性
	level_comp.required_exp_evaluator = get_experience_needed
	
	screen_size = get_viewport_rect().size
	
	PlayerManager.emit_signal("player_ready", self)
	

func _physics_process(delta):
	# 移动输入处理
	movement_input = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		movement_input.x -= 1
	if Input.is_action_pressed("move_right"):
		movement_input.x += 1
	if Input.is_action_pressed("move_up"):
		movement_input.y -= 1
	if Input.is_action_pressed("move_down"):
		movement_input.y += 1
	var movement_direction = movement_input.normalized()
	set_velocity(movement_direction * character_comp.move_speed)
	move_and_slide()
	var velocity = velocity


# TODO: 受到伤害，返回实际受到的伤害
func take_damage(damage_amount: float) -> float:
	return character_comp.take_damage(damage_amount)
	

func get_experience_needed(level: int) -> float:
	return level * (level + 1) * 2.5

func _on_pickup_component_item_absorbed(pickable_item: BasePickableItem):
	# 经验的处理方法
	if pickable_item is Experience:
		level_comp.gain_exp(pickable_item.amount)
		return


func _on_character_component_health_changed(old_value, new_value):
	($HealthBar as ProgressBar).value = new_value / character_comp.max_health
