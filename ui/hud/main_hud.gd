extends CanvasLayer


@onready var experience_bar := $ExperienceBar as ProgressBar
@onready var level_diplay_text := $ExperienceBar/LevelDisplayText as Label

var level_component : LevelComponent

func _ready():
	if (is_instance_valid(PlayerManager.player_character)
		and PlayerManager.player_character.is_node_ready()):
		_on_player_ready(PlayerManager.player_character)
	else:
		PlayerManager.connect("player_ready", _on_player_ready)

func _on_player_ready(player_character: PlayerCharacter):
	level_component = player_character.level_component
	if is_instance_valid(level_component):
		level_component.connect("exp_changed", _on_player_exp_changed)
		level_component.connect("level_up", _on_player_level_up)


func _on_player_exp_changed(new_exp: float) -> void:
	experience_bar.value = new_exp / level_component.get_current_required_exp()


func _on_player_level_up(new_level: int) -> void:
	level_diplay_text.text = "Lv. %d" % new_level
