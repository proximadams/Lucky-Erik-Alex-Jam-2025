extends Node

var rng
var yellSounds = [
	load('res://SoundEffects/Unmixed/yellSound1.wav'),
	load('res://SoundEffects/Unmixed/yellSound2.wav'),
	load('res://SoundEffects/Unmixed/yellSound3.wav'),
	load('res://SoundEffects/Unmixed/yellSound4.wav'),
	load('res://SoundEffects/Unmixed/yellSound5.wav'),
	load('res://SoundEffects/Unmixed/yellSound6.wav'),
]

var numDeathsTotalArr = [0, 0]
var numDevicesConnected = 0
var musicVolume = 1.0# range between 0.0 and 1.0 (inclusive)

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var _res = Input.connect('joy_connection_changed', _on_joy_connection_changed)

func get_random_yell_sound():
	var index = rng.randi_range(0, yellSounds.size() -2)
	var result = yellSounds[index]
	yellSounds.remove_at(index)
	yellSounds.append(result)
	return result

func refresh_music_volume():
	set_music_volume(musicVolume)

# fractionValue is between 0.0 and 1.0 (inclusive)
func set_music_volume(fractionValue: float) -> void:
	musicVolume = fractionValue
	for musicChild in MusicPlayer.get_children():
		if musicChild is AudioStreamPlayer:
			musicChild.volume_db = (musicChild.baseVolumeDB + 80.0) * pow(musicVolume, 0.25) - 80.0

func _on_joy_connection_changed(_device: int, connected: bool) -> void:
	if connected:
		numDevicesConnected += 1
	else:
		numDevicesConnected -= 1

	if numDevicesConnected < 0:
		# should never be called but just to be safe...
		numDevicesConnected = 0
