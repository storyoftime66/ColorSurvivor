class_name ItemType extends Resource
## 用于记录固定的道具信息


@export_group("Item Properties")
@export var name : String			              ## 道具名称
@export var icon : Texture2D                      ## 道具图标
@export var leveled_descriptions : Array[String]  ## 每一级的道具描述
