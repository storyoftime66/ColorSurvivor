extends Node

var level_node: Node

var player_bonus: Dictionary = {}
var weapons: Dictionary = {}

func _ready():
	level_node = get_parent().get_node("Main")

func obtain_weapon(wepaon_scene: PackedScene) -> void:
	if weapons.has(wepaon_scene):
		weapons[wepaon_scene].upgrade()
	else:
		var weapon = wepaon_scene.instantiate() as BaseWeapon
		weapon.apply_bonus(player_bonus)
		
		var player_character = PlayerManager.player_character
		weapons[wepaon_scene] = weapon
		player_character.add_child(weapon)
		weapon.owner = player_character
