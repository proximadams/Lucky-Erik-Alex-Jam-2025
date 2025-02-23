extends CanvasLayer

@export var round = 1

func _ready() -> void:
	$FightVoiceSounds.get_child(round -1).play()

func set_paused(pauseValue: bool) -> void:
	get_tree().paused = pauseValue
