# 包含和敌人相关的全局逻辑

extends Node

# 所有敌人
var debug_enemy_scene: PackedScene
var level_node: Node
var experience_scene: PackedScene = preload("res://pickable_items/experience/experience.tscn")


@onready var enemy_spawning_timer := %EnemySpawningTimer as Timer
var enemy_spawner_timers: Array[Timer] = []

var _interval_index = 0
const intervals = [
	[0.0, 1.0, 1],
	[30.0, 0.8, 1],
	[60.0, 0.6, 1],
	[90.0, 0.4, 1],
	[120.0, 0.2, 1],
	[180.0, 0.1, 2],
	[240.0, 0.1, 3],
]  # (游戏时间, 生成间隔, 生成器数量)

# 游戏时间追踪
var game_time: float = 0.0  ## 游戏时间（秒）



func _ready():
	level_node = get_parent().get_node("Main")
	debug_enemy_scene = load("res://characters/enemies/debug_enemy/debug_enemy.tscn")

	enemy_spawner_timers.append(enemy_spawning_timer)



func _process(delta: float) -> void:
	# 累计游戏时间
	game_time += delta

	# 根据游戏时间调整生成敌人的间隔
	if _interval_index + 1 < intervals.size():
		var next_time_interval = intervals[_interval_index + 1]
		var _next_game_time = next_time_interval[0]
		# 如果达到下一个时间点，更新生成间隔
		if game_time >= _next_game_time:

			if next_time_interval[2] > enemy_spawner_timers.size():
				for i in range(next_time_interval[2] - enemy_spawner_timers.size()):
					var timer = Timer.new()
					timer.one_shot = false
					timer.autostart = true
					timer.timeout.connect(_on_EnemySpawning_timeout)
					enemy_spawner_timers.append(timer)
					self.add_child(timer)
			for timer in enemy_spawner_timers:
				timer.wait_time = next_time_interval[1]

			_interval_index += 1


# 获取最近敌人的位置
func get_closest_enemy_position() -> Vector2:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest_pos := Vector2(2000, 0).rotated(randf() * 360.0)
	var closest_distance_square := INF
	var player_position = PlayerManager.player.position
	var temp_distance_square: float
	for enemy in enemies:
		temp_distance_square = enemy.position.distance_squared_to(player_position)
		if closest_distance_square > temp_distance_square:
			closest_distance_square = temp_distance_square
			closest_pos = enemy.position
	return closest_pos


# 生成敌人
func _on_EnemySpawning_timeout() -> void:
	var enemy = debug_enemy_scene.instantiate()
	var angle = randf() * 2 * PI
	var relative_position = Vector2(cos(angle) * 800, sin(angle) * 800)
	# 在玩家屏幕外生成，随机旋转
	enemy.position = PlayerManager.player.position + relative_position
	enemy.rotation = randf() * 2 * PI

	level_node.add_child(enemy)
	enemy.add_to_group("enemies")


func spawn_experience(experience_amount: float, pos: Vector2) -> void:
	var experience = experience_scene.instantiate() as Experience
	experience.amount = experience_amount
	experience.position = pos
	level_node.call_deferred("add_child", experience)
