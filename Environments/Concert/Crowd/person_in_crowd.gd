extends Node3D

var timeLeftCurrentAnimation = 0.0

# Called when the node enters the scene tree for the first time.
func _pick_animation() -> void:
	var randomAnimationIndex = Global.rng.randi_range(1, 3)
	$AnimationPlayer.play('a' + str(randomAnimationIndex))
	$AnimationPlayer.seek(Global.rng.randf_range(0.0, 0.5))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timeLeftCurrentAnimation -= delta
	if timeLeftCurrentAnimation < 0.0:
		timeLeftCurrentAnimation += Global.rng.randf_range(3.0, 10.0)
		_pick_animation()
