class_name ItemComponent extends Node
# 道具组件，拥有该组件的场景被视为“道具”。
# 该类为纯数据类，该类实例的名称需要命名为“ItemComponent“。
# @see also res://ui/gameplay/item_tile.gd

@export_group("Item Properties")
@export var item_name : String			## 道具名称
@export var item_icon : Texture2D		## 道具图标
@export var description : String		## 道具效果描述(废弃)
@export var leveled_descriptions : Array[String]	## 每一级的道具描述
