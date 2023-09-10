# 包含和玩家角色相关的全局逻辑

extends Node

var main_scene: Node
var player_character: PlayerCharacter
var player_position: Vector2
var player_orientation: float

var damage_number_scene: PackedScene = preload("res://ui/gameplay/damage_number.tscn")

func _ready():
	main_scene = get_parent().get_node("Main")
	player_character = main_scene.get_node("PlayerCharacter")

func _process(delta):
	player_position = player_character.global_position
	
func spawn_damage_number(global_pos: Vector2, damage_amount: float) -> void:
	var damage_number = damage_number_scene.instance()
	damage_number.global_position = global_pos
	damage_number.number = damage_amount
	
	main_scene.add_child(damage_number)
	
