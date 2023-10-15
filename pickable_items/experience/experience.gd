class_name Experience extends BasePickableItem

var amount := 1.0

func on_absorbed(picker: Node2D) -> void:
	PlayerManager.player_gain_experience(amount)
	super.on_absorbed(picker)
