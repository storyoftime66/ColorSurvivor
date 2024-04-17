class_name UltimateVoidEyeProjectile extends BaseProjectile
## 环绕的虚空之眼


var weapon : UltimateVoidEye
var active : bool = false

@onready var laser_collision := $CollisionShape2D as CollisionShape2D
@onready var laser_shape := laser_collision.shape as RectangleShape2D
@onready var laser_sprite := $Laser as Sprite2D
@onready var laser_duration := $LaserDuration as Timer

const BASE_LENGTH = 158.0 * 0.2
const BASE_WIDTH = 8.0
const BASE_OFFSET = 158.0 * 0.1


func _ready():
	update_attributes()


func _physics_process(delta):
	# do nothing
	pass
	

func update_attributes():
	damage = weapon.attributes["damage"].value
	area = weapon.attributes["area"].value
	speed = weapon.attributes["speed"].value
	duration = weapon.attributes["duration"].value
	impact = weapon.attributes["impact"].value
	
	laser_shape.size = Vector2(BASE_LENGTH * area, BASE_WIDTH)
	var new_position = Vector2(BASE_OFFSET * area, 0.0)
	laser_collision.position = new_position
	laser_sprite.scale = Vector2(0.2, area * 0.2)
	laser_sprite.position = new_position
	
	if active:
		laser_shape.set_deferred("disabled", false)
		laser_sprite.show()
	else:
		laser_shape.set_deferred("disabled", true)
		laser_sprite.hide()
	


func start_lasing() -> void:
	active = true
	laser_collision.set_deferred("disabled", false)
	laser_sprite.show()
	laser_duration.start(duration)


func stop_lasing() -> void:
	active = false
	laser_collision.set_deferred("disabled", true)
	laser_sprite.hide()


func _on_hit(body):
	var enemy = body as BaseEnemy
	if enemy != null:
		var impact_impulse = Vector2(1.0, 0.0).rotated(global_rotation) * impact
		var actual_damage = enemy.take_damage(damage, impact_impulse)
		PlayerManager.spawn_damage_number(enemy.position, actual_damage)

