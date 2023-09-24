extends CanvasLayer


@onready var experience_bar := $ExperienceBar as ProgressBar
@onready var level_diplay_text := $ExperienceBar/LevelDisplayText as Label


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.connect("player_experience_changed", _on_player_experience_changed)
	PlayerManager.connect("player_level_up", _on_player_level_up)


func _on_player_experience_changed(new_experience: float) -> void:
	experience_bar.value = new_experience / PlayerManager.player_max_experience


func _on_player_level_up(new_level: int) -> void:
	level_diplay_text.text = "Lv. %d" % new_level
