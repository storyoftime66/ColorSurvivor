class_name ItemTile extends Control


# item_comp_scene，用于判断PackedScene中节点的类型
const item_comp_scene := preload("res://weapon_components/item_component/item_component.tscn")

@export var item_scene : PackedScene : ## 包含ItemComponent节点的场景
	set = set_item_scene

@onready var icon := $Margin/VBox/Icon as TextureRect
@onready var description := $Margin/VBox/DescriptionMargin/Scroll/Description as Label

func _ready():
	update_style()


func set_item_scene(value: PackedScene):
	if item_scene != value:
		item_scene = value
		update_style()


func update_style():
	if item_scene == null:
		return
		
	var state = item_scene.get_state()
	for node_idx in range(state.get_node_count()):
		if state.get_node_instance(node_idx) != item_comp_scene:
			continue
			
		# 读取item_component节点的默认值
		for prop_idx in range(state.get_node_property_count(node_idx)):
			match state.get_node_property_name(node_idx, prop_idx):
				"item_name":
					pass
				"item_icon":
					pass
				"description":
					pass
		break
