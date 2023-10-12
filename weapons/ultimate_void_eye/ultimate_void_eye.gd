class_name UltimateVoidEye extends BaseWeapon
## 虚空之眼，会在玩家角色身边盘旋，隔一段时间发射一次激光


var eyes: Array[UltimateVoidEyeProjectile]
var eye_num := 0:
	get:
		return eye_num
	set(value):
		eye_num = value
		hover_radius = 60 + 8.0 * eye_num
		hover_angular_velocity = 1.0 / hover_radius * max(attributes["speed"].value, 1.0)
var hover_radius := 50.0
var hover_angular_velocity := 0.0


func _ready():
	projectile_scene = preload("res://weapons/ultimate_void_eye/ultimate_void_eye_projectile.tscn")
	super._ready()


func spawn_projectile() -> void:
	var eye = create_projectile()
	eyes.append(eye)
	eye_num = eyes.size()
	
	add_child(eye)
	rearrange_children()
	
	
func rearrange_children() -> void:
	var angle = 2 * PI / eye_num
	for i in range(eye_num):
		eyes[i].rotation = angle * i
		eyes[i].position = Vector2(hover_radius, 0).rotated(angle * i)
	
	
func apply_bonus(attribute_name: String, bonus: CommonTypes.Attribute) -> void:
	super.apply_bonus(attribute_name, bonus)
	match attribute_name:
		"speed":
			hover_angular_velocity = 1.0 / hover_radius * max(attributes["speed"].value, 1.0)
		"amount":
			var new_eye_num = int(attributes["amount"].value)
			while new_eye_num > eye_num:
				spawn_projectile()

func _process(delta):
	rotate(hover_angular_velocity * delta)
		

func _on_ShootingTimer_timeout():
	pass
