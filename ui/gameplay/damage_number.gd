extends Node2D

class_name DamageNumber

var number: float = 999.0
var duration: float = 1.0

func _ready():
	$Number.text = str(int(number))
	$LifeSpan.start(duration)
	$AnimationPlayer.play("fade")

func _on_LifeSpan_timeout():
	queue_free()
