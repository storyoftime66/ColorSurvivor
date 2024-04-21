class_name DamageAreaIndicatorComponent extends Node
## 伤害范围指示器武器组件


@export var indicator_class : PackedScene		## 范围指示器类

# 在指定位置生成指示器
func spawn_indicator(
	target_position: Vector2,
	lifespan: float = 1.0,
	setup_params: Dictionary = {}
) -> BaseAreaIndicator:
	var indicator = indicator_class.instantiate() as BaseAreaIndicator
	indicator.top_level = true
	indicator.lifespan = lifespan
	indicator.setup_params = setup_params
	
	add_child(indicator)
	indicator.global_position = target_position
	
	return indicator
