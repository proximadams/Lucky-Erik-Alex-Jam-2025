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

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()

func get_random_yell_sound():
	var index = rng.randi_range(0, yellSounds.size() -2)
	var result = yellSounds[index]
	yellSounds.remove_at(index)
	yellSounds.append(result)
	return result
