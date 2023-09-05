extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player


# Called when the node enters the scene tree for the first time.
func _ready():
	player = $PlayerCharacter
	print("Main ready")
	
	var magic_missle = load("res://weapons/magic_missle/magic_missle.tscn").instance()
	player.add_child(magic_missle)
	magic_missle.owner = player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
