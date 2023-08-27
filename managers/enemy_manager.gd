# 包含和敌人相关的全局逻辑

extends Node

# 所有敌人
var enemies: Array

var debug_enemy_scene: PackedScene
var main_scene: Node

func _ready():
	main_scene = get_parent().get_node("Main")
	debug_enemy_scene = load("res://characters/enemies/debug_enemy/debug_enemy.tscn")

# 获取最近敌人的位置
func get_closest_enemy_position() -> Vector2:
	return Vector2()

#func _process(delta):
#	pass


func _on_EnemySpawning_timeout():
	var enemy = debug_enemy_scene.instance()
	var angle = randf() * 2 * PI
	var relative_position = Vector2(cos(angle) * 800, sin(angle) * 800)
	enemy.position = PlayerManager.player_position + relative_position
	main_scene.add_child(enemy)
	
