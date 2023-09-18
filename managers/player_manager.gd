extends Node

"""
包含和玩家角色相关的全局逻辑
"""

# 主场景节点
var main_node: Node
var player_character: PlayerCharacter
var player_character_scene: PackedScene = preload("res://characters/player/player_character.tscn")
var damage_number_scene: PackedScene = preload("res://ui/gameplay/damage_number.tscn")

# 玩家状态
var player_position: Vector2 = Vector2(0, 0)
var player_orientation: float = 0.0


func _ready():
	# 获取主场景，TODO: 优化获取主节点的方法
	main_node = get_parent().get_node("Main")
	
	# 生成玩家角色
	player_character = player_character_scene.instance()
	register_player_character(player_character)
	main_node.add_child(player_character)
	player_character.position = player_character.get_viewport_rect().size * 0.5
	
	# 赋予初始武器
#	WeaponManager.obtain_weapon(load("res://weapons/magic_missle/magic_missle.tscn"))
	WeaponManager.obtain_weapon(load("res://weapons/knifes/knifes.tscn"))
#	WeaponManager.obtain_weapon(load("res://weapons/onion/onion.tscn"))


# 更新玩家状态
func _process(delta):
	if is_instance_valid(player_character):
		player_position = player_character.position
		
		if player_character.movement_input.length_squared() > 0.0:
			player_orientation = rad2deg(Vector2.ZERO.angle_to_point(Vector2(1, 0)))


func register_player_character(new_player_character: PlayerCharacter) -> void:
	EnemyManager.player_character = new_player_character
	WeaponManager.player_character = new_player_character


func spawn_damage_number(pos: Vector2, damage_amount: float) -> void:
	var damage_number = damage_number_scene.instance()
	damage_number.position = pos
	damage_number.number = damage_amount
	
	main_node.add_child(damage_number)
