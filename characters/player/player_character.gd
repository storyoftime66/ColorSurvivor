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
	level_comp.required_xp_evaluator = get_required_xp
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
	

func get_required_xp(level: int) -> float:
	return level * (level + 1) * 2.5


func _on_pickup_component_item_absorbed(pickable_item: BasePickableItem):
	# 经验的处理方法
	if pickable_item is Experience:
		level_comp.gain_xp(pickable_item.amount)
		return


func _on_character_component_health_changed(old_value, new_value):
	($HealthBar as ProgressBar).value = new_value / character_comp.max_health


func _on_level_component_level_up(new_level):
	# TODO
	get_tree().paused = true
	var item_page_scene = load("res://ui/gameplay/obtaining_item_page.tscn") as PackedScene
	var item_page = item_page_scene.instantiate() as ObtainingItemPage
	var weapon_list = PlayerManager.weapon_list.duplicate()
#	weapon_list.shuffle()
#	item_page.item_scenes = weapon_list.slice(0, 3)
	item_page.item_scenes = [load("res://weapons/onion/onion.tscn"),]
	HUD.add_child(item_page)
