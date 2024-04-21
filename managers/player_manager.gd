extends Node
## 包含和玩家、玩家角色相关的全局逻辑

signal player_ready(player_character: PlayerCharacter)

var level_node: Node

# 玩家角色及组件
var player_character: PlayerCharacter
var player_character_scene: PackedScene = preload("res://characters/player/player_character.tscn")
var player_level_component: LevelComponent

# 玩家角色状态
var player_position: Vector2 = Vector2(0, 0)
var player_orientation: float = 0.0

var damage_number_scene: PackedScene = preload("res://ui/gameplay/damage_number.tscn")


func _ready():
	# 获取主场景，TODO: 优化获取主节点的方法
	level_node = get_parent().get_node("Main")
	
	# 生成玩家角色
	player_character = player_character_scene.instantiate()
	level_node.add_child(player_character)
	player_character.position = player_character.get_viewport_rect().size * 0.5
	
	call_deferred("initialize_weapons")

func initialize_weapons() -> void:
	# 赋予初始武器
#	obtain_weapon(load("res://weapons/magic_missle/magic_missle.tscn"))
#	obtain_weapon(load("res://weapons/knifes/knifes.tscn"))
#	obtain_weapon(load("res://weapons/onion/onion.tscn"))
	obtain_weapon(load("res://weapons/ultimate_void_eye/ultimate_void_eye.tscn"))
#	obtain_weapon(load("res://weapons/fuel_drop/fuel_drop.tscn"))


func _process(delta):
	# 更新玩家角色状态
	if is_instance_valid(player_character):
		player_position = player_character.position
		
		if player_character.movement_input.length_squared() > 0.0:
			player_orientation = player_character.movement_input.angle()


# 工具方法
func spawn_damage_number(pos: Vector2, damage_amount: float) -> void:
	var damage_number = damage_number_scene.instantiate()
	damage_number.position = pos
	damage_number.number = damage_amount
	
	level_node.add_child(damage_number)
	

# 武器相关
var player_bonus: Dictionary = {}
# 所有武器，Dictionary[PackedScene, BaseWeapon]
var weapons: Dictionary = {}

func obtain_weapon(wepaon_scene: PackedScene) -> void:
	if weapons.has(wepaon_scene):
		weapons[wepaon_scene].upgrade()
	else:
		var weapon = wepaon_scene.instantiate() as BaseWeapon
		weapon.apply_all_bonus(player_bonus)
		
		var player_character = PlayerManager.player_character
		weapons[wepaon_scene] = weapon
		weapon.player_character = player_character
		player_character.add_child(weapon)
		weapon.owner = player_character
