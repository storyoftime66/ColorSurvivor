class_name UltimateVoidEye extends BaseWeapon
## [终极武器]虚空之眼，会在玩家角色身边盘旋，隔一段时间发射一次激光


# 武器升级所增加的基础属性增量
# 例：从1级升到2级会添加attribute_delta_list[1]描述的属性增量
var attribute_upgrade_deltas : Array[Dictionary] = [
	{},														# level 0[invalid]
	{"damage": Attribute.new(15.0)},						# level 1
	{"area": Attribute.new(50.0)},							# level 2
	{"speed": Attribute.new(40.0)},							# level 3
	{"duration": Attribute.new(1.0)},						# level 4
	{"area": Attribute.new(50.0)},							# level 5
	{"speed": Attribute.new(40.0)},							# level 6
	{"damage": Attribute.new(30.0)},						# level 7
]

var eyes: Array[UltimateVoidEyeProjectile]
var eye_num := 0:
	get:
		return eye_num
	set(value):
		eye_num = value
		hover_radius = 40 + 4.0 * eye_num
		hover_angular_velocity = 1.0 / hover_radius * max(attributes["speed"].value, 1.0)
var hover_radius := 50.0
var hover_angular_velocity := 0.0

# 用于保存下一个发射的眼睛的索引
var lasing_queue: Array[int] = []
# 同时需要触发发射的眼睛数量
var lasing_num := 0


func _ready():
	shooting_interval = 0.6 / amount
	shooting_interval_timer.wait_time = shooting_interval
	super._ready()

# [override]
func spawn_projectile() -> BaseProjectile:
	var eye = create_projectile() as UltimateVoidEyeProjectile
	eye.weapon = self
	eyes.append(eye)
	eye_num = eyes.size()
	
	add_child(eye)
	relayout_children()
	
	return eye

func relayout_children() -> void:
	shooting_interval = 0.6 / amount
	
	var angle = 2 * PI / eye_num
	for i in range(eye_num):
		eyes[i].rotation = angle * i
		eyes[i].position = Vector2(hover_radius, 0).rotated(angle * i)

func apply_bonus(attribute_name: String, bonus: Attribute) -> void:
	super.apply_bonus(attribute_name, bonus)
	match attribute_name:
		"speed":
			hover_angular_velocity = 1.0 / hover_radius * max(attributes["speed"].value, 1.0)
		"amount":
			var new_eye_num = int(attributes["amount"].value)
			while new_eye_num > eye_num:
				spawn_projectile()
		_:
			for eye in eyes:
				eye.update_attributes()

func _process(delta):
	rotate(hover_angular_velocity * delta)

func shoot() -> void:
	shooting_timer.start(attributes["cooldown"].value + attributes["duration"].value)
	
	if eyes.size() > 0:
		lasing_num += 1
		lasing_queue.push_back(0)
		if shooting_interval_timer.is_stopped():
			shooting_interval_timer.start()

func shoot_single_projectile() -> void:
	for _i in range(lasing_num):
		var eye_to_lase = lasing_queue.pop_front()
		if eye_to_lase != null:
			eyes[eye_to_lase].start_lasing()
			if eye_to_lase + 1 < eye_num:
				lasing_queue.push_back(eye_to_lase + 1)
			else:
				lasing_num -= 1
		else:
			lasing_num = 0
			shooting_interval_timer.stop()
			break

# [override] 武器升级
func upgrade() -> void:
	if level >= attribute_upgrade_deltas.size():
		return
	for key in attribute_upgrade_deltas[level].keys():
		weapon_attributes[key].apply_modifier(attribute_upgrade_deltas[level][key])
		apply_player_bonus(key)
	level += 1
