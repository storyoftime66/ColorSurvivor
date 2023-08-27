# 包含和玩家角色相关的全局逻辑

extends Node

var main_scene: Node
var player_character: PlayerCharacter
var player_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	main_scene = get_parent().get_node("Main")
	player_character = main_scene.get_node("PlayerCharacter")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_position = player_character.position
