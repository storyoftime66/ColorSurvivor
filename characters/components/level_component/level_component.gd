class_name LevelComponent extends Node
# 等级组件

var level := 1 :		## 等级
	get:
		return level
var total_exp := 0.0:	## 总获取的经验值
	get:
		return total_exp
var exp := 0.0:			## 当前经验值（不包括前面等级的经验）
	get:
		return exp
var required_exp_evaluator : Callable	## 经验计算公式，需要传入对应等级

signal level_up(new_level)			## 等级提升
signal exp_gained(exp_gained)		## 获得经验

var required_exp_cache := [0.0]		## 所需经验值列表缓存


# 获取指定等级升级所需的经验值
func get_required_exp(target_level) -> float:
	if required_exp_cache.size() < target_level:
		var current_level = required_exp_cache.size()
		while current_level <= target_level:
			required_exp_cache.append(required_exp_evaluator.call(current_level))
			current_level += 1
	return required_exp_cache[target_level]


# 获得经验值
func gain_exp(value: float):
	exp += value
	emit_signal("exp_gained", value)
	while(exp >= get_required_exp(level)):
		exp -= get_required_exp(level)
		level += 1
		emit_signal("level_up", level)
