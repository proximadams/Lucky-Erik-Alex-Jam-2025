extends CanvasLayer

@export var fightRound = 1

var baseVolumeOffset = 15.0# this is a shameful hack

func _ready() -> void:
	$FightVoiceSounds.get_child(fightRound -1).volume_db = baseVolumeOffset + Global.get_sfx_db()
	$FightVoiceSounds.get_child(fightRound -1).play()

func set_paused(pauseValue: bool) -> void:
	get_tree().paused = pauseValue
