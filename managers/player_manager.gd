extends Node
## 包含和玩家、玩家角色相关的全局逻辑

signal player_ready(player_character: PlayerCharacter)

var level_node: Node

# 玩家角色及组件
var players : Array[Player] = []			## 玩家信息
var player_character_scene: PackedScene = preload("res://characters/player/player_character.tscn")
var player_level_component: LevelComponent

var damage_number_scene: PackedScene = preload("res://ui/gameplay/damage_number.tscn")
var weapon_list := [
	preload("res://weapons/fuel_drop/fuel_drop.tscn"),				## 爆炸液滴
	preload("res://weapons/knifes/knifes.tscn"),					## 飞刀
	preload("res://weapons/magic_missle/magic_missle.tscn"),		## 魔法飞弹
	preload("res://weapons/onion/onion.tscn"),						## 洋葱
	preload("res://weapons/ultimate_void_eye/ultimate_void_eye.tscn"),	## 虚空之眼
]

func _ready():
	# 获取主场景，TODO: 优化获取主节点的方法
	level_node = get_parent().get_node("Main")
	
	# 生成玩家
	add_player()

	
func add_player() -> void:
	var player = Player.new()
	var character = player_character_scene.instantiate()
	player.character = character
	players.append(player)
	
	level_node.add_child(character)
	character.position = character.get_viewport_rect().size * 0.5
	add_child(player)
	connect("player_ready", player.setup_player)
	connect("player_ready", initialize_weapons) ## TODO：移到别处


func initialize_weapons(character: PlayerCharacter) -> void:
	# 赋予初始武器
#	character.weapon_comp.obtain_weapon(load("res://weapons/magic_missle/magic_missle.tscn"))
#	character.weapon_comp.obtain_weapon(load("res://weapons/knifes/knifes.tscn"))
#	character.weapon_comp.obtain_weapon(load("res://weapons/onion/onion.tscn"))
#	character.weapon_comp.obtain_weapon(load("res://weapons/ultimate_void_eye/ultimate_void_eye.tscn"))
	character.weapon_comp.obtain_weapon(load("res://weapons/fuel_drop/fuel_drop.tscn"))


# 工具方法
func spawn_damage_number(pos: Vector2, damage_amount: float) -> void:
	var damage_number = damage_number_scene.instantiate()
	damage_number.position = pos
	damage_number.number = damage_amount
	
	level_node.add_child(damage_number)
	
