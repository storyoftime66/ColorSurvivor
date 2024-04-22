class_name WeaponComponent extends Node2D
# 武器组件
# 使角色可与武器交互


# 角色属性增益，会作用于武器，类型为Dictionary[String, CommonTypes.Attribute]
var bonus: Dictionary = {}

# 武器，类型为Dictionary[PackedScene, BaseWeapon]
var weapons: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	# 角色对武器的增益
	bonus["damage"] = CommonTypes.Attribute.new()			## 伤害增益
	bonus["area"] = CommonTypes.Attribute.new()				## 范围增益
	bonus["speed"] = CommonTypes.Attribute.new()			## 发射物飞行速度增益
	bonus["duration"] = CommonTypes.Attribute.new()			## 持续时间增益
	bonus["amount"] = CommonTypes.Attribute.new()			## 发射物数量增益
	bonus["cooldown"] = CommonTypes.Attribute.new()			## 冷却时间增益
	bonus["penetration"] = CommonTypes.Attribute.new()		## 可穿透数量增益
	bonus["impact"] = CommonTypes.Attribute.new()			## 击退增益


# 获得武器
func obtain_weapon(wepaon_scene: PackedScene) -> void:
	if weapons.has(wepaon_scene):
		weapons[wepaon_scene].upgrade()
	else:
		var weapon = wepaon_scene.instantiate() as BaseWeapon
		weapon.apply_all_bonus(bonus)
		
		weapons[wepaon_scene] = weapon
		weapon.weapon_comp = self
		add_child(weapon)
		weapon.owner = self
