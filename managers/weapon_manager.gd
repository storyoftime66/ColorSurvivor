extends Node

var main_node: Node

var player_character: PlayerCharacter
var player_bonus: Dictionary = {}
var weapons: Dictionary = {}

func _ready():
	main_node = get_parent().get_node("Main")

func obtain_weapon(wepaon_scene: PackedScene) -> void:
	if weapons.has(wepaon_scene):
		weapons[wepaon_scene].upgrade()
	else:
		var weapon = wepaon_scene.instance() as BaseWeapon
		weapon.apply_bonus(player_bonus)
		
		weapons[wepaon_scene] = weapon
		player_character.add_child(weapon)
		weapon.owner = player_character
