extends Sprite3D

@export var maxTime = 5.0
var currTime = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currTime += delta
	modulate.a = (maxTime - currTime)/maxTime
	if(currTime > maxTime):
		queue_free()
