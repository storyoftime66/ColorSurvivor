extends CanvasLayer


@onready var experience_bar := $ExperienceBar as ProgressBar
@onready var level_diplay_text := $ExperienceBar/LevelDisplayText as Label

var level_comp : LevelComponent

func _ready():
	if (is_instance_valid(PlayerManager.players[0])
		and is_instance_valid(PlayerManager.players[0].character)
		and PlayerManager.players[0].character.is_node_ready()):
		_on_player_ready(PlayerManager.players[0].player_character)
	else:
		PlayerManager.connect("player_ready", _on_player_ready)

func _on_player_ready(player_character: PlayerCharacter):
	level_comp = player_character.level_comp
	if is_instance_valid(level_comp):
		level_comp.connect("exp_changed", _on_player_exp_changed)
		level_comp.connect("level_up", _on_player_level_up)


func _on_player_exp_changed(new_exp: float) -> void:
	experience_bar.value = new_exp / level_comp.get_current_required_exp()


func _on_player_level_up(new_level: int) -> void:
	level_diplay_text.text = "Lv. %d" % new_level
