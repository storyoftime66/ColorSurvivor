class_name BaseAreaIndicator extends Node2D
# 范围指示器基类

# 指示器属性
var lifespan := 1.0				## 持续时间
var setup_params := {}			## 初始化參數，在子类中自定义

func _ready():
	$Lifespan.start(lifespan)

func _on_lifespan_timeout():
	queue_free()
