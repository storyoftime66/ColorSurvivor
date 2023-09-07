# 包含和敌人相关的全局逻辑

extends Node

# 所有敌人
var debug_enemy_class: PackedScene
var main_scene: Node
var player_character: Node2D

func _ready():
	main_scene = get_parent().get_node("Main")
	debug_enemy_class = load("res://characters/enemies/debug_enemy/debug_enemy.tscn")

# 获取最近敌人的位置
func get_closest_enemy_position() -> Vector2:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest_pos := Vector2(2000, 0).rotated(randf() * 360.0)
	var closest_distance_square := INF
	var player_position = PlayerManager.player_position
	var temp_distance_square: float
	for enemy in enemies:
		temp_distance_square = enemy.global_position.distance_squared_to(player_position)
		if closest_distance_square > temp_distance_square:
			closest_distance_square = temp_distance_square
			closest_pos = enemy.global_position
	return closest_pos

#func _process(delta):
#	pass

# 生成敌人
func _on_EnemySpawning_timeout() -> void:
	var enemy = debug_enemy_class.instance()
	var angle = randf() * 2 * PI
	var relative_position = Vector2(cos(angle) * 800, sin(angle) * 800)
	enemy.position = PlayerManager.player_position + relative_position
	
	main_scene.add_child(enemy)
	enemy.add_to_group("enemies")
