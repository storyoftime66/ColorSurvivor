extends CanvasLayer


@onready var experience_bar := $ExperienceBar as ProgressBar
@onready var level_diplay_text := $ExperienceBar/LevelDisplayText as Label

var level_comp : LevelComponent

func _ready():
	if (is_instance_valid(PlayerManager.player)
		and is_instance_valid(PlayerManager.player.character)
		and PlayerManager.player.character.is_node_ready()):
		_on_player_ready(PlayerManager.player.player_character)
	else:
		PlayerManager.connect("player_ready", _on_player_ready)

func _on_player_ready(player_character: PlayerCharacter):
	level_comp = player_character.level_comp
	if is_instance_valid(level_comp):
		level_comp.connect("xp_changed", _on_player_xp_changed)
		level_comp.connect("level_up", _on_player_level_up)


func _on_player_xp_changed(new_xp: float) -> void:
	experience_bar.value = new_xp / level_comp.get_current_required_xp()


func _on_player_level_up(new_level: int) -> void:
	level_diplay_text.text = "Lv. %d" % new_level
