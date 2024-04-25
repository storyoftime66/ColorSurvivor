class_name ObtainingItemPage extends Control
# 获取道具页面


var item_scenes : Array = []

@onready var hbox := $HBox as HBoxContainer
const tile_scene : PackedScene = preload("res://ui/gameplay/item_tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for tile in get_children():
		hbox.remove_child(tile)
		
	for item_scene in item_scenes:
		var item_tile = tile_scene.instantiate()
		item_tile.item_scene = item_scene
		item_tile.connect("item_tile_clicked", _on_item_tile_clicked)
		hbox.add_child(item_tile)

func _on_item_tile_clicked(item_scene: PackedScene):
	PlayerManager.players[0].weapon_comp.obtain_weapon(item_scene)
	get_tree().paused = false
	queue_free()
