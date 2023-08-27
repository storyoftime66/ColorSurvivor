extends KinematicBody2D

# 死亡时触发
signal died

export (float) var speed = 100
export (float) var health = 10

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	move_and_slide((PlayerManager.player_position - position).normalized() * speed)


func apply_damage(damage: float):
	health -= damage
	if health <= 0:
		emit_signal("died")
		queue_free()
