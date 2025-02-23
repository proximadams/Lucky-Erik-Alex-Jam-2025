extends Node3D

var nextRoundScene: String

func go_to_next_round():
	if nextRoundScene:
		get_tree().change_scene_to_file(nextRoundScene)
