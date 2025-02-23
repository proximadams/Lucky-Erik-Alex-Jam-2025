extends AudioStreamPlayer

@export var baseVolumeDB = 0.0

var oldBaseVolumeDB = 0.0

func _process(_delta: float) -> void:
	if baseVolumeDB != oldBaseVolumeDB:
		Global.refresh_music_volume()
		oldBaseVolumeDB = baseVolumeDB
