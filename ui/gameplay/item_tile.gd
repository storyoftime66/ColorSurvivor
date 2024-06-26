class_name ItemTile extends Control
# 道具卡片，用于显示道具信息

signal item_tile_clicked(item_scene: PackedScene)		## 道具卡片被点击时

# ItemComponent节点的名称，通过名称来识别节点。TODO: 改进
const ITEM_COMP_NAME := "ItemComponent"

@export var item_scene : PackedScene : ## 包含ItemComponent节点的场景
	set = set_item_scene

@onready var icon_node := $Margin/VBox/Icon as TextureRect
@onready var item_name_node := $Margin/VBox/Name as Label
@onready var description_node := $Margin/VBox/DescriptionMargin/Scroll/Description as Label

var item_name : String
var icon : Texture2D
var description : String
var leveled_descriptions : Array[String]

func _ready():
	update_style()


func set_item_scene(value: PackedScene):
	# 判断is_node_ready()是为了防止设置默认值时触发该方法
	if item_scene != value:
		item_scene = value
		if is_node_ready():
			update_style()


func update_style():
	if item_scene == null:
		return
		
	var state = item_scene.get_state()
	for node_idx in range(state.get_node_count()):
		# 通过名称判断节点是否为ItemComponent
		if state.get_node_name(node_idx) != ITEM_COMP_NAME:
			continue
			
		# 读取item_component节点的默认值
		for prop_idx in range(state.get_node_property_count(node_idx)):
			match state.get_node_property_name(node_idx, prop_idx):
				"item_name":
					item_name = state.get_node_property_value(node_idx, prop_idx)
					item_name_node.text = item_name
				"item_icon":
					icon = state.get_node_property_value(node_idx, prop_idx)
					icon_node.texture = icon
				"leveled_descriptions":
					leveled_descriptions = state.get_node_property_value(node_idx, prop_idx)
					var level = 0
					var weapon_comp = PlayerManager.player.weapon_comp as WeaponComponent
					if is_instance_valid(weapon_comp) and weapon_comp.weapons.has(item_scene):
						level = weapon_comp.weapons[item_scene].level
						if leveled_descriptions.size() <= level:
							level = 0	# 防止超出描述列表长度报错
					description_node.text = leveled_descriptions[level]
		break


func _on_gui_input(event: InputEvent):
	if event.is_pressed():
		emit_signal("item_tile_clicked", item_scene)
