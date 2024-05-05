class_name CommonTypes extends Object


# 属性类
# 属性可以添加加成和减益，并通过一个计算公式得出实际属性值
class Attribute:
	signal value_changed
	
	# 属性值，current_value的别名
	var value: float: get = get_value
	
	var base_value: float: get = get_base_value, set = set_base_value
	var current_value: float: get = get_value
	var addition: float = 0.0: get = get_addition, set = set_addition
	var multiplier: float = 0.0: get = get_multiplier, set = set_multiplier
	var divider: float = 0.0: get = get_divider, set = set_divider
	var is_dirty: bool = true
	
	func get_value() -> float:
		if is_dirty:
			current_value = (base_value * (1.0 + multiplier) + addition) * max(0.01, 1.0 - divider)
			is_dirty = false
		return current_value
	
	func set_base_value(new_value: float) -> void:
		base_value = new_value
		is_dirty = true
		emit_signal("value_changed", value)
	
	func get_base_value() -> float:
		return base_value
	
	func set_addition(new_value: float) -> void:
		addition = new_value
		is_dirty = true
		emit_signal("value_changed", value)
	
	func get_addition() -> float:
		return addition
	
	func set_multiplier(new_value: float) -> void:
		multiplier = new_value
		is_dirty = true
		emit_signal("value_changed", value)
	
	func get_multiplier() -> float:
		return multiplier
	
	func set_divider(new_value: float) -> void:
		divider = new_value
		is_dirty = true
		emit_signal("value_changed", value)
	
	func get_divider() -> float:
		return divider
	
	func apply_modifier(modifier: Attribute) -> void:
		base_value += modifier.base_value
		addition += modifier.addition
		multiplier += modifier.multiplier
		divider += modifier.divider
		is_dirty = true
		emit_signal("value_changed", value)
	
	func duplicate_and_apply_modifier(modifier: Attribute) -> Attribute:
		var new_attribute = Attribute.new(base_value)
		new_attribute.is_dirty = true
		new_attribute.base_value = base_value + modifier.base_value
		new_attribute.addition = addition + modifier.addition
		new_attribute.multiplier = multiplier + modifier.multiplier
		new_attribute.divider = divider + modifier.divider
		return new_attribute
	
	func reset() -> void:
		addition = 0.0
		multiplier = 0.0
		divider = 0.0
		is_dirty = true
		emit_signal("value_changed", value)
	
	func _init(
		init_base_value: float = 0.0, init_addition: float = 0.0,
		init_multiplier: float = 0.0, init_divider: float = 0.0
	):
		base_value = init_base_value
		addition = init_addition
		multiplier = init_multiplier
		divider = init_divider
