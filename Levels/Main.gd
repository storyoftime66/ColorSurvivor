extends Node

var scene = preload("res://weapons/fuel_drop/fuel_drop.tscn")
var comp_scene = preload("res://weapon_components/damage_area_indicator_component/damage_area_indicator_component.tscn")
var base_comp_scene = preload("res://weapon_components/damage_area_indicator_component/circle_area_indicator.tscn")
var null_scene: PackedScene
var gd_scene = preload("res://characters/enemies/base_enemy.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	var state = scene.get_state()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
