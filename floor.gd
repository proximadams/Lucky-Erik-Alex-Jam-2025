extends StaticBody3D

@onready var startScale = scale

var playTimer = 0.0

const SHRINK_SPEED_MULT = 0.05

func _process(delta: float) -> void:
	playTimer += delta
	scale.x = startScale.x - (playTimer * SHRINK_SPEED_MULT)
	scale.y = startScale.y - (playTimer * SHRINK_SPEED_MULT)
	scale.z = startScale.z - (playTimer * SHRINK_SPEED_MULT)
	if scale.x < 0.1:
		queue_free()
