extends SpotLight3D

@export var playerNodePath: NodePath

@onready var player = get_node(playerNodePath)

func _process(delta: float) -> void:
	global_position = player.global_position
