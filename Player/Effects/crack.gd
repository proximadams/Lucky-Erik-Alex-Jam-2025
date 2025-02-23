extends Sprite3D

@export var maxTime = 5.0
var currTime = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currTime += delta
	if currTime > maxTime:
		queue_free()
