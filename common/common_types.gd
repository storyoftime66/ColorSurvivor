extends Object

class_name CommonTypes

# 属性类
# 属性可以添加加成和减益，并通过一个计算公式得出实际属性值
class Attribute:
	# 属性值，current_value的别名
	var value: float setget , get_value
	
	var base_value: float setget set_base_value, get_base_value
	var current_value: float setget , get_value
	var addition: float = 0.0 setget set_addition, get_addition
	var multiplier: float = 0.0 setget set_multiplier, get_multiplier
	var divider: float = 0.0 setget set_divider, get_divider
	var is_dirty: bool = true
	
	func get_value() -> float:
		if is_dirty:
			current_value = (base_value * (1.0 + multiplier) + addition) * max(0.01, 1.0 - divider)
			is_dirty = false
		return current_value
	
	func set_base_value(new_value: float) -> void:
		base_value = new_value
		is_dirty = true
	
	func get_base_value() -> float:
		return base_value
	
	func set_addition(new_value: float) -> void:
		addition = new_value
		is_dirty = true
	
	func get_addition() -> float:
		return addition
	
	func set_multiplier(new_value: float) -> void:
		multiplier = new_value
		is_dirty = true
	
	func get_multiplier() -> float:
		return multiplier
	
	func set_divider(new_value: float) -> void:
		divider = new_value
		is_dirty = true
	
	func get_divider() -> float:
		return divider
	
	func add_modifiers(other: Attribute) -> void:
		addition += other.addition
		multiplier += other.multiplier
		divider += other.divider
		is_dirty = true
	
	func reset() -> void:
		addition = 0.0
		multiplier = 0.0
		divider = 0.0
		is_dirty = true
	
	func _init(init_base_value: float):
		base_value = init_base_value
