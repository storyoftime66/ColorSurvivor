class_name Player extends Node
# 玩家类，包含玩家必要信息

var character : PlayerCharacter			## 玩家角色
var position : Vector2					## 角色全局位置
var orientation : float					## 角色朝向，单位度
var level_comp : LevelComponent			## 角色等级组件
var pickup_comp : PickupComponent		## 角色拾取组件
var weapon_comp : WeaponComponent		## 角色武器组件


func _process(delta):
	# 更新玩家角色状态
	if character.is_node_ready():
		position = character.global_position
		
		if character.movement_input.length_squared() > 0.1:
			orientation = character.movement_input.angle()


func setup_player(player_character: PlayerCharacter) -> void:
	request_ready()
	if character == player_character:
		position = character.global_position
		orientation = 0.0
		level_comp = character.level_comp
		pickup_comp = character.pickup_comp
		weapon_comp = character.weapon_comp
