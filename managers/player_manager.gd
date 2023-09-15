extends Node

"""
包含和玩家角色相关的全局逻辑
"""

var main_node: Node
var player_character: PlayerCharacter
var player_character_scene = preload("res://characters/player/player_character.tscn")

# 玩家状态
# 玩家角色的绝对位置
var player_position: Vector2 = Vector2(0, 0)
# 玩家角色的朝向，单位弧度
var player_orientation: float = 0.0

var damage_number_scene: PackedScene = preload("res://ui/gameplay/damage_number.tscn")

func _ready():
	# 获取主场景
	main_node = get_parent().get_node("Main")
	
	# 生成玩家角色
	player_character = player_character_scene.instance()
	register_player_character(player_character)
	main_node.add_child(player_character)
	player_character.global_position = player_character.get_viewport_rect().size * 0.5
	
	# 赋予初始武器
#	WeaponManager.obtain_weapon(load("res://weapons/magic_missle/magic_missle.tscn"))
#	WeaponManager.obtain_weapon(load("res://weapons/knifes/knifes.tscn"))
	WeaponManager.obtain_weapon(load("res://weapons/onion/onion.tscn"))

# 更新玩家状态
func _process(delta):
	if is_instance_valid(player_character):
		player_position = player_character.global_position
		
		if player_character.movement_input.length_squared() > 0.0:
			player_orientation = Vector2.RIGHT.angle_to(player_character.movement_input)
	
# 注册玩家角色
func register_player_character(new_player_character: PlayerCharacter) -> void:
	EnemyManager.player_character = new_player_character
	WeaponManager.player_character = new_player_character

# 显示伤害数字
func spawn_damage_number(global_pos: Vector2, damage_amount: float) -> void:
	var damage_number = damage_number_scene.instance()
	damage_number.global_position = global_pos
	damage_number.number = damage_amount
	
	main_node.add_child(damage_number)
