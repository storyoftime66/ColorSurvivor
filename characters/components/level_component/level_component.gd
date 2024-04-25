class_name LevelComponent extends Node
# 等级组件

var level := 1 :		## 等级
	get:
		return level
var total_xp := 0.0:	## 总获取的经验值
	get:
		return total_xp
var xp := 0.0:			## 当前经验值（不包括前面等级的经验）
	get:
		return xp
var required_xp_evaluator : Callable		## 经验计算公式，需要传入对应等级

signal level_up(new_level: int)				## 等级提升
signal xp_changed(new_xp: float)			## 经验值改变

var required_xp_cache : Array[float] = [0.0]		## 所需经验值列表缓存


# 获取指定等级升级所需的经验值
func get_required_xp(target_level) -> float:
	if required_xp_cache.size() <= target_level:
		var current_level = required_xp_cache.size()
		while current_level <= target_level:
			required_xp_cache.append(required_xp_evaluator.call(current_level))
			current_level += 1
	return required_xp_cache[target_level]


func get_current_required_xp() -> float:
	return get_required_xp(level)


# 获得经验值
func gain_xp(value: float):
	total_xp += value
	xp += value
	if value != 0:
		emit_signal("xp_changed", xp)
	while(xp >= get_current_required_xp()):
		xp -= get_current_required_xp()
		emit_signal("xp_changed", xp)
		level += 1
		emit_signal("level_up", level)
