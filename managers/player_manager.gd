extends Node
## 包含和玩家、玩家角色相关的全局逻辑


# 玩家升级
signal player_upgraded(level);

var level_node: Node
var player_character: PlayerCharacter
var player_character_scene: PackedScene = preload("res://characters/player/player_character.tscn")
var damage_number_scene: PackedScene = preload("res://ui/gameplay/damage_number.tscn")

# 玩家状态
var player_position: Vector2 = Vector2(0, 0)
var player_orientation: float = 0.0
var player_experience: float = 0.0
var player_level: int = 1
var player_level_experience_table = [10.0, 80.0, 640.0, 1600.0, 2880.0]


func _ready():
	# 获取主场景，TODO: 优化获取主节点的方法
	level_node = get_parent().get_node("Main")
	
	# 生成玩家角色
	player_character = player_character_scene.instantiate()
	level_node.add_child(player_character)
	player_character.position = player_character.get_viewport_rect().size * 0.5
	
	# 赋予初始武器
	WeaponManager.obtain_weapon(load("res://weapons/magic_missle/magic_missle.tscn"))
#	WeaponManager.obtain_weapon(load("res://weapons/knifes/knifes.tscn"))
#	WeaponManager.obtain_weapon(load("res://weapons/onion/onion.tscn"))


# 更新玩家状态
func _process(delta):
	print(player_level)	
	
	if is_instance_valid(player_character):
		player_position = player_character.position
		
		if player_character.movement_input.length_squared() > 0.0:
			player_orientation = player_character.movement_input.angle()


# 工具
func spawn_damage_number(pos: Vector2, damage_amount: float) -> void:
	var damage_number = damage_number_scene.instantiate()
	damage_number.position = pos
	damage_number.number = damage_amount
	
	level_node.add_child(damage_number)


# 玩家等级相关
func player_gain_experience(experience_amount: float) -> void:
	if experience_amount < 0.0:
		return
		
	player_experience += experience_amount
	while player_experience >= player_level_experience_table[player_level - 1]:
		player_experience -= player_level_experience_table[player_level - 1]
		player_upgrade()
	

func player_upgrade():
	player_level += 1
	emit_signal("player_upgrade", player_level)
