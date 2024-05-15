class_name BloodStainProjectile extends BaseProjectile
# 血迹
# 用于检测踩在其中的敌人。由于该发射物的特殊性，将其z index设为const.Z_INDEX_INDICATOR

var enemies_on_stain : Array[BaseEnemy] = []		## 在这块血迹上的敌人
var weapon : BloodStains							## 武器对象

@onready var collision := $CollisionShape2D as CollisionShape2D


func _ready():
	super._ready()
	self.set_physics_process(false)

func _on_hit(body):
	var enemy = body as BaseEnemy
	if is_instance_valid(enemy):
		enemies_on_stain.append(enemy)
		if weapon.enemies_on_stains.has(enemy):
			weapon.enemies_on_stains[enemy] += 1
		else:
			weapon.enemies_on_stains[enemy] = 1

# [override]
func destroy():
	# 销毁时移除敌人
	for enemy in enemies_on_stain:
		if weapon.enemies_on_stains.has(enemy):
			var count = weapon.enemies_on_stains[enemy] - 1
			if count <= 0:
				weapon.enemies_on_stains.erase(enemy)
			else:
				weapon.enemies_on_stains[enemy] = count
	super.destroy()
